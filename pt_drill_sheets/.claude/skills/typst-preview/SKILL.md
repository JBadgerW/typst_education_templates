---
name: typst-preview
description: Compile a .typ template directly with the Typst CLI to preview layout changes without running the Python pipeline. Use when iterating on multiplication_1.typ, division_1.typ, addition_1.typ, subtraction_1.typ, algebra_1.typ, or layout_template.typ.
---

To iterate on Typst layout directly without going through Python, compile a template file with the
system `typst` CLI:

```
typst compile multiplication_1.typ --font-path fonts
typst compile algebra_1.typ --font-path fonts
```

Each operation template checks `sys.inputs` for a `data` key first; when compiled this way (no
`--input data=...`), it falls back to reading a dummy JSON file in the repo root for problem data
instead: `dummy_data.json` (`a`/`b` fields) for the four fact-sheet templates, `dummy_algebra_data.json`
(`operation`, `unknown`, per-problem `family`/`member`/`reverse`) for `algebra_1.typ`. The real
pipeline (`drill_common.py` / `facts_as_algebra.py`) always passes `data`, so this fallback only
kicks in for standalone `typst compile` runs — it's what lets you preview layout without running
Python at all.

`layout_template.typ` also falls back to `dummy_data.json` for its own standalone preview (it only
shows `header`/`title-bar`), independently of whatever file is compiled as the main document — so a
standalone `algebra_1.typ` preview's title-bar text comes from `dummy_algebra_data.json` when
`algebra_1.typ` itself reads `data`, but from `dummy_data.json` when `layout_template.typ` reads its
own separate `data` binding during import. In the real pipeline both files see the same `sys.inputs`
payload, so this divergence only shows up in the no-`--input` standalone-preview path — harmless,
but don't be surprised if a standalone algebra preview's title-bar text looks like a fact sheet's.

Pass `--font-path fonts` (matching the `font_paths`/`ignore_system_fonts` used by
`drill_common.generate_sheet`) so the preview matches what the real pipeline produces.
