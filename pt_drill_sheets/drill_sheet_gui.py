import tempfile
import tkinter as tk
from pathlib import Path
from tkinter import filedialog, messagebox, ttk

import typst
from pypdf import PdfWriter

from drill_common import BASE_DIR, OPERATIONS, family_slug, generate_sheet, resolve_seed

MAX_FACTOR = 12
DEFAULT_COUNT = 90
FAMILY_COLUMNS = 4


class DrillSheetApp(ttk.Frame):
    def __init__(self, master):
        super().__init__(master, padding=12)
        master.title("Drill Sheet Generator")
        master.resizable(False, False)

        self.master_bg = ttk.Style(master).lookup("TFrame", "background")
        self.last_save_dir = BASE_DIR

        self.operation_var = tk.StringVar(value="Multiplication")
        self.family_vars = {
            n: tk.BooleanVar(value=True) for n in range(1, MAX_FACTOR + 1)
        }
        self.versions_var = tk.StringVar(value="1")
        self.separate_files_var = tk.BooleanVar(value=False)
        self.status_var = tk.StringVar()

        self.grid(row=0, column=0, sticky="nsew")
        self._build_operation_row()
        self._build_family_section()
        self._build_versions_row()
        self._build_actions()

    def _build_operation_row(self):
        row = ttk.Frame(self)
        row.grid(row=0, column=0, sticky="ew", pady=(0, 10))
        ttk.Label(row, text="Operation:").pack(side="left")
        ttk.Combobox(
            row,
            textvariable=self.operation_var,
            values=list(OPERATIONS.keys()),
            state="readonly",
            width=16,
        ).pack(side="left", padx=(8, 0))

    def _build_family_section(self):
        frame = ttk.LabelFrame(self, text="Fact Families", padding=10)
        frame.grid(row=1, column=0, sticky="ew", pady=(0, 10))

        for n in range(1, MAX_FACTOR + 1):
            r, c = divmod(n - 1, FAMILY_COLUMNS)
            tk.Checkbutton(
                frame,
                text=str(n),
                variable=self.family_vars[n],
                background=self.master_bg,
                activebackground=self.master_bg,
                highlightthickness=0,
            ).grid(row=r, column=c, sticky="w", padx=6, pady=3)

        button_row = ttk.Frame(frame)
        button_row.grid(
            row=(MAX_FACTOR - 1) // FAMILY_COLUMNS + 1,
            column=0,
            columnspan=FAMILY_COLUMNS,
            pady=(8, 0),
            sticky="w",
        )
        ttk.Button(button_row, text="Check All", command=self._check_all).pack(
            side="left"
        )
        ttk.Button(button_row, text="Uncheck All", command=self._uncheck_all).pack(
            side="left", padx=(6, 0)
        )

    def _check_all(self):
        for var in self.family_vars.values():
            var.set(True)

    def _uncheck_all(self):
        for var in self.family_vars.values():
            var.set(False)

    def _build_versions_row(self):
        row = ttk.Frame(self)
        row.grid(row=2, column=0, sticky="ew", pady=(0, 10))
        ttk.Label(row, text="Versions:").pack(side="left")
        ttk.Spinbox(row, textvariable=self.versions_var, from_=1, to=99, width=4).pack(
            side="left", padx=(8, 0)
        )
        tk.Checkbutton(
            row,
            text="Save each version as a separate file",
            variable=self.separate_files_var,
        ).pack(side="left", padx=(14, 0))

    def _build_actions(self):
        row = ttk.Frame(self)
        row.grid(row=3, column=0, sticky="ew", pady=(4, 0))
        ttk.Button(row, text="Save", command=self._on_save).pack(side="left")
        ttk.Button(row, text="Save As...", command=self._on_save_as).pack(
            side="left", padx=(6, 0)
        )

        status = ttk.Label(self, textvariable=self.status_var, foreground="gray")
        status.grid(row=4, column=0, sticky="w", pady=(6, 0))

    def _selected_families(self):
        return sorted(n for n, var in self.family_vars.items() if var.get())

    def _read_versions(self):
        versions_text = self.versions_var.get().strip()
        try:
            n_versions = int(versions_text)
        except ValueError:
            messagebox.showerror(
                "Invalid versions", "Number of versions must be a whole number."
            )
            return False, None
        if n_versions < 1:
            messagebox.showerror(
                "Invalid versions", "Number of versions must be at least 1."
            )
            return False, None
        return True, n_versions

    def _generate_one(self, families, output_path=None, output_dir=None, seed=None):
        operation = self.operation_var.get()
        return generate_sheet(
            operation=operation,
            families=families,
            max_factor=MAX_FACTOR,
            count=DEFAULT_COUNT,
            seed=seed,
            output_path=output_path,
            output_dir=output_dir,
            **OPERATIONS[operation],
        )

    def _generate(self, output_path=None, output_dir=None, seed=None):
        families = self._selected_families()
        if not families:
            messagebox.showerror(
                "No families selected", "Select at least one fact family."
            )
            return

        ok, n_versions = self._read_versions()
        if not ok:
            return

        try:
            if n_versions == 1:
                self._save_single(families, output_path, output_dir, seed)
            elif self.separate_files_var.get():
                self._save_separate(families, n_versions, output_dir)
            else:
                self._save_merged(families, n_versions, output_path, output_dir)
        except typst.TypstError as exc:
            messagebox.showerror(
                "Compile failed", f"Typst failed to compile the worksheet:\n{exc}"
            )

    def _save_single(self, families, output_path, output_dir, seed):
        _, saved_path = self._generate_one(
            families, output_path=output_path, output_dir=output_dir, seed=seed
        )
        self.last_save_dir = saved_path.parent
        self.status_var.set(f"Saved {saved_path.name} to {saved_path.parent}")

    def _save_separate(self, families, n_versions, output_dir):
        target_dir = Path(output_dir) if output_dir is not None else self.last_save_dir
        saved_paths = [
            self._generate_one(families, output_dir=target_dir)[1]
            for _ in range(n_versions)
        ]
        self.last_save_dir = saved_paths[-1].parent
        self.status_var.set(f"Saved {len(saved_paths)} files to {self.last_save_dir}")

    def _save_merged(self, families, n_versions, output_path, output_dir):
        if output_path is None:
            op = OPERATIONS[self.operation_var.get()]
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
        self.status_var.set(
            f"Saved {output_path.name} ({n_versions} versions) to {output_path.parent}"
        )

    def _on_save(self):
        self._generate(output_dir=self.last_save_dir)

    def _on_save_as(self):
        families = self._selected_families()
        if not families:
            messagebox.showerror(
                "No families selected", "Select at least one fact family."
            )
            return

        ok, n_versions = self._read_versions()
        if not ok:
            return

        if n_versions > 1 and self.separate_files_var.get():
            directory = filedialog.askdirectory(
                title="Choose a folder for the worksheet versions",
                initialdir=str(self.last_save_dir),
            )
            if directory:
                self._generate(output_dir=directory)
            return

        op = OPERATIONS[self.operation_var.get()]
        slug = family_slug(families, MAX_FACTOR)

        if n_versions > 1:
            default_name = f"{op['output_prefix']}_{slug}_{n_versions}_versions.pdf"
            seed = None
        else:
            seed = resolve_seed(None)
            default_name = f"{op['output_prefix']}_{slug}_{seed}.pdf"

        path = filedialog.asksaveasfilename(
            title="Save drill sheet as",
            defaultextension=".pdf",
            filetypes=[("PDF files", "*.pdf")],
            initialfile=default_name,
            initialdir=str(self.last_save_dir),
        )
        if path:
            self._generate(output_path=path, seed=seed)


def main():
    root = tk.Tk()
    style = ttk.Style(root)
    if "clam" in style.theme_names():
        style.theme_use("clam")
    DrillSheetApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
