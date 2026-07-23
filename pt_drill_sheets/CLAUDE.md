# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A generator for printable math drill sheets (addition, subtraction, multiplication, division fact
families). Python builds a set of problems and hands them to Typst as JSON; Typst renders a
two-page PDF (problem page + answer page) using a bundled font.

## Setup and commands

Dependencies are managed with `uv` (`uv.lock` + `pyproject.toml`, Python >=3.12 pinned via
`.python-version`). `requirements.txt` (just `typst==0.15.0`) is a lighter-weight `pip install -r`
alternative to the `uv` project.

Generate a sheet from the CLI, e.g.:

```
python new_multiplication_sheet.py --families 7 8 9 --max-factor 12 --count 90 --seed 12345
```

The other three entry points (`new_addition_sheet.py`, `new_subtraction_sheet.py`,
`new_division_sheet.py`) take identical flags. All flags are optional — omit `--families` for the
full table, omit `--seed` for a random one (it gets embedded in the output filename and printed on
the sheet so a run can be reproduced later).

Run the desktop GUI (Tkinter) instead of the CLI:

```
python drill_sheet_gui.py
```

To iterate on Typst layout directly without going through Python, compile a template file with the
system `typst` CLI — it will fall back to `dummy_data.json` for problem data (see "Dummy data
fallback" below):

```
typst compile multiplication_1.typ --font-path fonts
```

Pass `--font-path fonts` (matching the `font_paths`/`ignore_system_fonts` used by
`drill_common.generate_sheet`) so the preview matches what the real pipeline produces.

There is no test suite, linter, or formatter configured in this repo.

## Architecture

**`drill_common.py`** is the shared engine used by every entry point:
- `OPERATIONS` maps each operation name to its Typst template file, output filename prefix, and verb
  used in the worksheet subtitle (e.g. "Multiply the following families: 7-9, 12").
- `generate_problems` samples `(a, b)` pairs from the `max_factor` × `max_factor` grid, optionally
  restricted to pairs touching a given set of "families" (numbers), using a seeded `random.Random`.
- `generate_sheet` resolves/records the seed, builds the JSON payload (`seed`, `title`,
  `ws-details`, `problems`), and calls `typst.compile(...)` with `sys_inputs={"data": <json>}` plus
  `font_paths=["fonts"]` and `ignore_system_fonts=True` so rendering doesn't depend on what's
  installed on the machine. Output path defaults to `<prefix>_<family-slug>_<seed>.pdf` in the repo
  root, or can be overridden with `output_path`/`output_dir`.

**`new_<operation>_sheet.py`** files are thin CLI wrappers: build an argparser via
`build_arg_parser`, then call `generate_sheet(..., **OPERATIONS["<Operation>"])`.

**`drill_sheet_gui.py`** is a Tkinter/ttk GUI over the same `generate_sheet` function — checkboxes
for fact families 1–12, an operation dropdown, an optional seed field, and Save / Save As buttons.
Catches `typst.TypstError` and reports compile failures via a message box.

**Typst side** — each operation has its own template (`multiplication_1.typ`, `division_1.typ`,
`addition_1.typ`, `subtraction_1.typ`). Each one:
1. Reads `data` from `sys_inputs` (real pipeline) or falls back to `json("dummy_data.json")` when
   compiled directly — this fallback is what lets you `typst compile <file>.typ` standalone while
   experimenting with layout.
2. Defines an operation-specific glyph function (e.g. `multiplication`, `division`) that renders one
   problem as a small stacked table/grid, with an optional red bold answer.
3. Builds a `problem-grid` (all problems, `answer: false`) and an `answer-grid` (`answer: true`),
   laid out as a 10-column Typst `table`.
4. Stacks `header` + `title-bar` + `problem-grid` on page 1, then `pagebreak()`s and stacks an
   "Answers" heading + `title-bar` + `answer-grid` on page 2.

**`layout_template.typ`** is a partially-extracted shared layout: `header` (Name/Date/Timing/Counts
box) and `title-bar` (title + family description + seed) are defined here and imported by the four
operation templates (`#import "layout_template.typ": header, title-bar`). Page setup (`#set page`,
`#set text`), `answer-blank`, and each operation's own glyph function are **not** yet centralized —
they're still duplicated verbatim across the four `*_1.typ` files. When editing shared layout
(margins, fonts, header/title-bar), check whether the change needs to be mirrored into all four
operation files, and prefer moving more of the duplicated pieces into `layout_template.typ` if you're
touching them anyway.

**`claudes_glyph.typ`** is a standalone scratch file for prototyping the hand-drawn long-division
sign (the curved hook + bar) at large size before it was copied into `division_1.typ`'s `division`
function. Treat it as a design sandbox, not part of the pipeline.

**`fonts/`** bundles Nimbus Sans (OTF, chosen as a free metrically-close substitute for Helvetica
Neue) so PDF output is font-stable regardless of what's installed on the host — always compiled with
`ignore_system_fonts=True` and `font_paths=["fonts"]`.

**`main.py`** is an unused `uv init` stub ("Hello from pt-drill-sheets!") — not part of the
generation pipeline.

## Notes

- `TODO.md` is a running scratchpad of in-progress design decisions/TODOs (e.g. header
  layout, font choice) — check it for context on why something looks unfinished, but it isn't
  polished documentation.
- `README.md` is currently empty.
