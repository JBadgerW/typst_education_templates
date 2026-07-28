# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A generator for printable math drill sheets. Two worksheet families exist: plain fact sheets
(addition, subtraction, multiplication, division) and algebra sheets (the same four operations,
rephrased as "solve for x"). Python decides *what* a sheet contains (which problems, which side of
an equation is hidden); Typst decides *how* it's laid out. Python hands Typst a JSON payload; Typst
renders a two-page PDF (problem page + answer page) using a bundled font.

## Setup and commands

Generate a sheet from the CLI, e.g.:

```
python new_multiplication_sheet.py --families 7 8 9 --max-factor 12 --count 90 --seed 12345
```

The other three entry points (`new_addition_sheet.py`, `new_subtraction_sheet.py`,
`new_division_sheet.py`) take identical flags. All flags are optional — omit `--families` for the
full table, omit `--seed` for a random one (it gets embedded in the output filename and printed on
the sheet so a run can be reproduced later).

`new_algebra_sheet.py` covers all four operations through one entry point (`--operation`, default
Addition) plus `--unknown` (default `x`): non-letter characters are stripped and the remaining
letters deduped into a set, then each problem draws its own unknown letter randomly from that set
(so e.g. `--unknown xyn` mixes x/y/n across a sheet). Otherwise it takes the same flags.

Run the desktop GUI (PySide6) instead of the CLI:

```
python drill_sheet_gui.py
```

See `.claude/skills/typst-preview/SKILL.md` for compiling a `.typ` template directly with the Typst
CLI to preview layout changes without running the Python pipeline.

There is no test suite, linter, or formatter configured in this repo.

## Architecture

**`drill_common.py`** is the shared engine behind the plain fact-sheet pipeline. Its `write_sheet`
(resolve output path, call `typst.compile`) is also reused by the algebra pipeline below.

**`new_<operation>_sheet.py`** files are thin CLI wrappers: build an argparser via
`build_arg_parser`, then call `generate_sheet(..., **OPERATIONS["<Operation>"])`.

**`facts_as_algebra.py`** is the algebra pipeline's equivalent of `drill_common.py`. Its
`parse_unknown_letters` strips non-letters from the raw `--unknown` input and dedupes what's left
into a sorted list. `generate_algebra_problems` samples ordered `(family, member)` pairs via
`fact_families.get_facts` (not `drill_common.generate_problems` — see the division/subtraction
fact-family caveat in `TODO.md`) and assigns each problem its own random `reverse` flag (which side
of the equation the unknown lands on) and its own random `unknown` letter drawn from that list.
`generate_algebra_sheet` packages those into JSON (`operation`, per-problem
`family`/`member`/`reverse`/`unknown`) and calls `drill_common.write_sheet`. `new_algebra_sheet.py`
is its CLI wrapper. Python only decides *which* problems, *which side* is hidden, and *which letter*
is used — the actual equation text, the per-operation identity (e.g. subtraction's
`x - family = member`), and the red/bold answer are entirely Typst's job in `algebra_1.typ`.

**`drill_sheet_gui.py`** is a PySide6 GUI, structured as a `QTabWidget` with one tab per
worksheet family: `FactSheetTab` (plain fact sheets) and `AlgebraTab` (algebra sheets, with an added
"unknown letter" field). Both subclass `WorksheetTab` (a `QWidget`), which holds the shared
scaffolding (operation dropdown, fact-family checkboxes, versions row, Save/Save As) and calls each
subclass's `_generate_one`. Add a new worksheet family by subclassing `WorksheetTab` and adding it to
the `addTab(...)` calls in `main()`.

**Typst side** — each operation has its own template (`multiplication_1.typ`, `division_1.typ`,
`addition_1.typ`, `subtraction_1.typ`), rendering a compact stacked-digit glyph per problem.
**`algebra_1.typ`** instead renders each problem as an inline equation (`algebra-equation`), reading
`operation` plus per-problem `family`/`member`/`reverse`/`unknown` from the JSON and computing the
equation's known/solved values itself — Python never builds Typst syntax. `unknown` arrives as a
plain string, which Typst would otherwise show upright like a number, so every occurrence is wrapped
in `math.italic(unknown)` to match how a literal variable typed directly in math source renders.

**`layout_template.typ`** exports only `header` (Name/Date/Timing/Counts box) and `title-bar` (title
+ family description + seed), imported by all five operation templates
(`#import "layout_template.typ": header, title-bar`). It deliberately contains no per-operation
content (problem grids, glyphs): importing a `.typ` file evaluates its whole module, so any code
there referencing `data.problems` would need every importer's problem shape (`a`/`b` for fact
sheets, `family`/`member`/`reverse` for algebra) to match, which they don't. Page setup (`#set
page`, `#set text`), `answer-blank`, and each operation's own glyph/equation function are **not**
centralized — they're duplicated verbatim across all five `*_1.typ`/`algebra_1.typ` files. When
editing shared layout (margins, fonts, header/title-bar), check whether the change needs to be
mirrored into all five operation files.

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
