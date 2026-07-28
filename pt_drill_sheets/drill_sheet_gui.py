import sys
import tempfile
from pathlib import Path

import typst
from pypdf import PdfWriter
from PySide6.QtWidgets import (
    QApplication,
    QCheckBox,
    QComboBox,
    QFileDialog,
    QGridLayout,
    QGroupBox,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QMessageBox,
    QPushButton,
    QSpinBox,
    QStyleFactory,
    QTabWidget,
    QVBoxLayout,
    QWidget,
)

from drill_common import BASE_DIR, OPERATIONS, family_slug, generate_sheet, resolve_seed
from facts_as_algebra import ALGEBRA_OPERATIONS, generate_algebra_sheet, parse_unknown_letters

MAX_FACTOR = 12
DEFAULT_COUNT = 90
DEFAULT_ALG_COUNT = 50
FAMILY_COLUMNS = 4


class WorksheetTab(QWidget):
    """Shared scaffolding for a worksheet-generator tab: operation dropdown,
    fact-family checkboxes, a versions row, and Save / Save As actions.
    Subclasses supply the operations dict, how to generate one sheet, and
    (optionally) extra controls and validation of their own."""

    def __init__(self, parent, operations, default_operation):
        super().__init__(parent)
        self.operations = operations
        self.last_save_dir = BASE_DIR
        self.family_checkboxes = {}

        layout = QVBoxLayout(self)
        layout.setContentsMargins(12, 12, 12, 12)
        layout.setSpacing(10)

        self._build_operation_row(layout, default_operation)
        self._build_extra_controls(layout)
        self._build_operations_section(layout)
        self._build_family_section(layout)
        self._build_versions_row(layout)
        self._build_actions(layout)

    def _build_operation_row(self, layout, default_operation):
        row = QHBoxLayout()
        row.addWidget(QLabel("Operation:"))
        self.operation_combo = QComboBox()
        self.operation_combo.addItems(list(self.operations.keys()))
        self.operation_combo.setCurrentText(default_operation)
        row.addSpacing(8)
        row.addWidget(self.operation_combo)
        row.addStretch()
        layout.addLayout(row)

    def _build_extra_controls(self, layout):
        """Hook for subclasses to add fields between the operation row and
        the fact-family checkboxes. No-op by default."""

    def _build_operations_section(self, layout):
        """Hook for subclasses to add an operations panel (e.g. for a "Mixed"
        operation mode) between the extra controls and the fact-family
        checkboxes. No-op by default."""

    def _build_family_section(self, layout):
        box = QGroupBox("Fact Families")
        grid = QGridLayout()
        grid.setContentsMargins(10, 10, 10, 10)

        for n in range(1, MAX_FACTOR + 1):
            r, c = divmod(n - 1, FAMILY_COLUMNS)
            checkbox = QCheckBox(str(n))
            checkbox.setChecked(True)
            self.family_checkboxes[n] = checkbox
            grid.addWidget(checkbox, r, c)

        button_row = QHBoxLayout()
        check_all_button = QPushButton("Check All")
        check_all_button.clicked.connect(self._check_all)
        uncheck_all_button = QPushButton("Uncheck All")
        uncheck_all_button.clicked.connect(self._uncheck_all)
        button_row.addWidget(check_all_button)
        button_row.addWidget(uncheck_all_button)
        button_row.addStretch()
        grid.addLayout(
            button_row, (MAX_FACTOR - 1) // FAMILY_COLUMNS + 1, 0, 1, FAMILY_COLUMNS
        )

        box.setLayout(grid)
        layout.addWidget(box)

    def _check_all(self):
        for checkbox in self.family_checkboxes.values():
            checkbox.setChecked(True)

    def _uncheck_all(self):
        for checkbox in self.family_checkboxes.values():
            checkbox.setChecked(False)

    def _build_versions_row(self, layout):
        row = QHBoxLayout()
        row.addWidget(QLabel("Versions:"))
        self.versions_spinbox = QSpinBox()
        self.versions_spinbox.setMinimum(1)
        self.versions_spinbox.setMaximum(99)
        row.addSpacing(8)
        row.addWidget(self.versions_spinbox)
        self.separate_files_checkbox = QCheckBox("Save each version as a separate file")
        row.addSpacing(14)
        row.addWidget(self.separate_files_checkbox)
        row.addStretch()
        layout.addLayout(row)

    def _build_actions(self, layout):
        row = QHBoxLayout()
        save_button = QPushButton("Save")
        save_button.clicked.connect(self._on_save)
        save_as_button = QPushButton("Save As...")
        save_as_button.clicked.connect(self._on_save_as)
        row.addWidget(save_button)
        row.addSpacing(6)
        row.addWidget(save_as_button)
        row.addStretch()
        layout.addLayout(row)

        self.status_label = QLabel()
        self.status_label.setStyleSheet("color: gray;")
        layout.addWidget(self.status_label)

    def _show_error(self, title, message):
        QMessageBox.critical(self, title, message)

    def _selected_families(self):
        return sorted(n for n, checkbox in self.family_checkboxes.items() if checkbox.isChecked())

    def _validate_extra(self):
        """Hook for subclasses to validate their own extra controls before
        generation. Return False (after showing its own error dialog) to
        abort. No-op by default."""
        return True

    def _generate_one(self, families, output_path=None, output_dir=None, seed=None):
        raise NotImplementedError

    def _generate(self, output_path=None, output_dir=None, seed=None):
        families = self._selected_families()
        if not families:
            self._show_error("No families selected", "Select at least one fact family.")
            return

        n_versions = self.versions_spinbox.value()

        if not self._validate_extra():
            return

        try:
            if n_versions == 1:
                self._save_single(families, output_path, output_dir, seed)
            elif self.separate_files_checkbox.isChecked():
                self._save_separate(families, n_versions, output_dir)
            else:
                self._save_merged(families, n_versions, output_path, output_dir)
        except typst.TypstError as exc:
            # Any other exception (OSError writing the file, pypdf errors
            # during merge, etc.) is not caught here and will propagate.
            self._show_error(
                "Compile failed", f"Typst failed to compile the worksheet:\n{exc}"
            )

    def _save_single(self, families, output_path, output_dir, seed):
        _, saved_path = self._generate_one(
            families, output_path=output_path, output_dir=output_dir, seed=seed
        )
        self.last_save_dir = saved_path.parent
        self.status_label.setText(f"Saved {saved_path.name} to {saved_path.parent}")

    def _save_separate(self, families, n_versions, output_dir):
        target_dir = Path(output_dir) if output_dir is not None else self.last_save_dir
        saved_paths = [
            self._generate_one(families, output_dir=target_dir)[1]
            for _ in range(n_versions)
        ]
        self.last_save_dir = saved_paths[-1].parent
        self.status_label.setText(f"Saved {len(saved_paths)} files to {self.last_save_dir}")

    def _save_merged(self, families, n_versions, output_path, output_dir):
        if output_path is None:
            op = self.operations[self.operation_combo.currentText()]
            slug = family_slug(families, MAX_FACTOR)
            base = Path(output_dir) if output_dir is not None else self.last_save_dir
            output_path = (
                base / f"{op['output_prefix']}_{slug}_{n_versions}versions.pdf"
            )
        else:
            output_path = Path(output_path)

        with tempfile.TemporaryDirectory() as tmp_dir:
            tmp_paths = [
                self._generate_one(families, output_dir=tmp_dir)[1]
                for _ in range(n_versions)
            ]
            writer = PdfWriter()
            for tmp_path in tmp_paths:
                writer.append(str(tmp_path))
            with open(output_path, "wb") as f:
                writer.write(f)
            writer.close()

        self.last_save_dir = output_path.parent
        self.status_label.setText(
            f"Saved {output_path.name} ({n_versions} versions) to {output_path.parent}"
        )

    def _on_save(self):
        self._generate(output_dir=self.last_save_dir)

    def _on_save_as(self):
        families = self._selected_families()
        if not families:
            self._show_error("No families selected", "Select at least one fact family.")
            return

        n_versions = self.versions_spinbox.value()

        if n_versions > 1 and self.separate_files_checkbox.isChecked():
            directory = QFileDialog.getExistingDirectory(
                self,
                "Choose a folder for the worksheet versions",
                str(self.last_save_dir),
            )
            if directory:
                self._generate(output_dir=directory)
            return

        op = self.operations[self.operation_combo.currentText()]
        slug = family_slug(families, MAX_FACTOR)

        if n_versions > 1:
            default_name = f"{op['output_prefix']}_{slug}_{n_versions}_versions.pdf"
            seed = None
        else:
            seed = resolve_seed(None)
            default_name = f"{op['output_prefix']}_{slug}_{seed}.pdf"

        path, _selected_filter = QFileDialog.getSaveFileName(
            self,
            "Save drill sheet as",
            str(Path(self.last_save_dir) / default_name),
            "PDF files (*.pdf)",
        )
        if path:
            if not path.lower().endswith(".pdf"):
                path += ".pdf"
            self._generate(output_path=path, seed=seed)


class FactSheetTab(WorksheetTab):
    def __init__(self, parent=None):
        super().__init__(parent, operations=OPERATIONS, default_operation="Multiplication")

    def _generate_one(self, families, output_path=None, output_dir=None, seed=None):
        operation = self.operation_combo.currentText()
        return generate_sheet(
            operation=operation,
            families=families,
            max_factor=MAX_FACTOR,
            count=DEFAULT_COUNT,
            seed=seed,
            output_path=output_path,
            output_dir=output_dir,
            **self.operations[operation],
        )


class AlgebraTab(WorksheetTab):
    def __init__(self, parent=None):
        super().__init__(parent, operations=ALGEBRA_OPERATIONS, default_operation="Addition")

    def _build_extra_controls(self, layout):
        row = QHBoxLayout()
        row.addWidget(QLabel("Unknown letter(s):"))
        self.unknown_line_edit = QLineEdit("x")
        self.unknown_line_edit.setFixedWidth(80)
        row.addSpacing(8)
        row.addWidget(self.unknown_line_edit)
        row.addStretch()
        layout.addLayout(row)

    def _build_operations_section(self, layout):
        self.operations_groupbox = QGroupBox("Operations")
        row = QHBoxLayout()
        row.setContentsMargins(10, 10, 10, 10)

        self.operation_checkboxes = {}
        for name in ("Addition", "Subtraction", "Multiplication", "Division"):
            checkbox = QCheckBox(name)
            checkbox.setChecked(True)
            self.operation_checkboxes[name] = checkbox
            row.addWidget(checkbox)
        row.addStretch()

        self.operations_groupbox.setLayout(row)
        self.operations_groupbox.setEnabled(False)
        layout.addWidget(self.operations_groupbox)

        self.operation_combo.currentTextChanged.connect(self._on_operation_changed)

    def _on_operation_changed(self, text):
        self.operations_groupbox.setEnabled(text == "Mixed")

    def _selected_operations(self):
        return [
            name.lower()
            for name, checkbox in self.operation_checkboxes.items()
            if checkbox.isChecked()
        ]

    def _validate_extra(self):
        try:
            parse_unknown_letters(self.unknown_line_edit.text())
        except ValueError:
            self._show_error(
                "Invalid unknown letters",
                "Enter at least one letter, e.g. x or xyn. Problems will draw "
                "their unknown randomly from whichever letters you enter.",
            )
            return False

        if self.operation_combo.currentText() == "Mixed" and not self._selected_operations():
            self._show_error(
                "No operations selected",
                "Select at least one operation to mix together.",
            )
            return False

        return True

    def _generate_one(self, families, output_path=None, output_dir=None, seed=None):
        operation = self.operation_combo.currentText()
        entry = self.operations[operation]
        operations = (
            self._selected_operations() if operation == "Mixed" else [entry["op"]]
        )
        return generate_algebra_sheet(
            operation=operation,
            operations=operations,
            families=families,
            max_factor=MAX_FACTOR,
            count=DEFAULT_ALG_COUNT,
            seed=seed,
            unknown=self.unknown_line_edit.text(),
            output_path=output_path,
            output_dir=output_dir,
            typst_file=entry["typst_file"],
            output_prefix=entry["output_prefix"],
        )


def main():
    app = QApplication(sys.argv)
    if "Fusion" in QStyleFactory.keys():
        app.setStyle("Fusion")

    window = QTabWidget()
    window.setWindowTitle("Drill Sheet Generator")
    window.addTab(FactSheetTab(window), "Fact Sheets")
    window.addTab(AlgebraTab(window), "Algebra")

    # QTabWidget has no layout() of its own to apply a size constraint to;
    # its stacked pages already share one stable size hint (the largest of
    # the two tabs), so lock the window to that size directly.
    window.adjustSize()
    window.setFixedSize(window.sizeHint())
    window.show()

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
