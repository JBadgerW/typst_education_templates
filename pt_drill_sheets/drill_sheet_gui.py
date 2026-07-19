import subprocess
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

from drill_common import BASE_DIR, OPERATIONS, family_slug, generate_sheet

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
        self.family_vars = {n: tk.BooleanVar(value=True) for n in range(1, MAX_FACTOR + 1)}
        self.seed_var = tk.StringVar()
        self.status_var = tk.StringVar()

        self.grid(row=0, column=0, sticky="nsew")
        self._build_operation_row()
        self._build_family_section()
        self._build_seed_row()
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
        ttk.Button(button_row, text="Check All", command=self._check_all).pack(side="left")
        ttk.Button(button_row, text="Uncheck All", command=self._uncheck_all).pack(
            side="left", padx=(6, 0)
        )

    def _check_all(self):
        for var in self.family_vars.values():
            var.set(True)

    def _uncheck_all(self):
        for var in self.family_vars.values():
            var.set(False)

    def _build_seed_row(self):
        row = ttk.Frame(self)
        row.grid(row=2, column=0, sticky="ew", pady=(0, 10))
        ttk.Label(row, text="Seed (optional):").pack(side="left")
        ttk.Entry(row, textvariable=self.seed_var, width=12).pack(side="left", padx=(8, 0))
        ttk.Label(row, text="Leave blank for random", foreground="gray").pack(
            side="left", padx=(8, 0)
        )

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

    def _read_seed(self):
        seed_text = self.seed_var.get().strip()
        if not seed_text:
            return True, None
        try:
            return True, int(seed_text)
        except ValueError:
            messagebox.showerror("Invalid seed", "Seed must be a whole number.")
            return False, None

    def _generate(self, output_path=None, output_dir=None):
        families = self._selected_families()
        if not families:
            messagebox.showerror("No families selected", "Select at least one fact family.")
            return

        ok, seed = self._read_seed()
        if not ok:
            return

        op = OPERATIONS[self.operation_var.get()]

        try:
            used_seed, saved_path = generate_sheet(
                families=families,
                max_factor=MAX_FACTOR,
                count=DEFAULT_COUNT,
                seed=seed,
                output_path=output_path,
                output_dir=output_dir,
                **op,
            )
        except FileNotFoundError:
            messagebox.showerror(
                "Typst not found",
                "Could not find the 'typst' command. Make sure it is installed and on your PATH.",
            )
            return
        except subprocess.CalledProcessError:
            messagebox.showerror("Compile failed", "Typst failed to compile the worksheet.")
            return

        self.last_save_dir = saved_path.parent
        self.status_var.set(f"Saved {saved_path.name} to {saved_path.parent}")

    def _on_save(self):
        self._generate(output_dir=self.last_save_dir)

    def _on_save_as(self):
        op = OPERATIONS[self.operation_var.get()]
        families = self._selected_families()
        seed_hint = self.seed_var.get().strip() or "random"
        slug = family_slug(families, MAX_FACTOR) if families else "none"
        default_name = f"{op['output_prefix']}_{slug}_{seed_hint}.pdf"

        path = filedialog.asksaveasfilename(
            title="Save drill sheet as",
            defaultextension=".pdf",
            filetypes=[("PDF files", "*.pdf")],
            initialfile=default_name,
            initialdir=str(self.last_save_dir),
        )
        if path:
            self._generate(output_path=path)


def main():
    root = tk.Tk()
    style = ttk.Style(root)
    if "clam" in style.theme_names():
        style.theme_use("clam")
    DrillSheetApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
