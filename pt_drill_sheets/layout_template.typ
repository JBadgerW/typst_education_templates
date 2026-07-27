#import sys: inputs

// Compile this file directly (no --input data=...) to use dummy_data.json
// for layout experiments. The real pipeline in drill_common.py always
// passes "data", so it's unaffected.
#let data = if "data" in sys.inputs {
  json(bytes(sys.inputs.at("data")))
} else {
  json("dummy_data.json")
}
#let seed = data.seed
#let title = data.title
#let ws-details = data.ws-details

#set page(
  paper: "us-letter",
  margin: (
    top: 0.35in,
    left: 0.5in,
    right: 0.5in,
    bottom: 1.5in, //  Why does 1.5in == 0.5?
  ),
)

#set text(
  font: "Nimbus Sans",
  size: 12pt,
)

#let answer-blank(width) = box(
  width: width,
  inset: 0pt,
  stroke: (bottom: 0.7pt),
)

// BEGINNING OF DOCUMENT CONTENT

// HEADER: Name/Date // Timing // Best counts
#let header = grid(
  columns: (auto, auto),
  column-gutter: 1fr,
  grid(
    align: bottom,
    rows: (auto, 0.75cm),

    [Name #answer-blank(3in)],
    [Date #answer-blank(3.5cm)],
  ),

  grid.cell(
    stroke: 1pt,
    {
      show table.cell: set text(size: 10pt)
      table(
        columns: (auto, auto),
        rows: (0.75cm, 0.75cm),
        column-gutter: 0.25cm,
        stroke: none,
        align: bottom,

        [Timing: #answer-blank(1.5cm) sec],
        [\# correct #answer-blank(1.5cm) /min],

        [], [\# wrong #answer-blank(1.5cm) /min],
      )
    },
  ),
)

#let title-bar = table(
  columns: (auto, 1fr, auto),
  stroke: none,
  table.cell(
    inset: 4pt,
    fill: black,
    stroke: 1pt,
    text(size: 11pt, fill: white, weight: "bold")[#title],
  ),
  [#ws-details],
  [#text(size: 8pt)[Seed: #seed]],
)

// Standalone preview only (typst compile layout_template.typ --font-path fonts):
// shows header + title-bar on their own, since that's all this file exports.
#header
#title-bar

