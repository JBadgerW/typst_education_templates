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
#let subtitle = data.subtitle
#let worksheet-problems = data.problems.map(p => (p.a, p.b))

#set page(
  paper: "us-letter",
  margin: (
    top: 0.25in,
    left: 0.5in,
    right: 0.5in,
    bottom: 0.85in, //  Why on earth does 0.85in = 0.5in? 
  ) 
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

#let multiplication(a, b, product, answer: false) = table(
  columns: (auto, auto),
  align: (right, right),
  stroke: none,

  [], [#a],
  [$times$], [#b],

  table.hline(),

  [], if answer { [#product] } else { [] },
)

// BEGINNING OF DOCUMENT CONTENT
//
// Name and Date header
#grid(
  columns: (auto, auto),
  column-gutter: 1fr,
  grid(
    rows: (auto, 0.75cm),
    [Name #answer-blank(3in)],
    grid.cell(align: bottom)[Date #answer-blank(3.5cm)],
  ),
  grid.cell(
    stroke: 0.7pt,
    table(
      columns: (auto, auto),
      column-gutter: (0.5cm),
      stroke: none,
      [\# correct #answer-blank(2cm)],
      [\# wrong #answer-blank(2cm)],
      [timing #answer-blank(2cm) sec],
      [freq #answer-blank(2cm) /min]
    )
  )
)
#table(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  rows: (auto, 1fr),
  column-gutter: 0pt,
  inset: (top: 7pt, right: 10pt, left:10pt, bottom: 5pt),

  table.cell(
    inset: 4pt, 
    fill: black, 
    text(size: 11pt, fill: white, weight: "bold")[#title]
  ),

  table.cell(
    stroke: (
      right: none,
      top: none,
    ),
    colspan: 7
  )[#subtitle],

  table.cell(
    stroke: (
      left: none,
      right: none,
      top: none,
    ),
    colspan: 2, 
    align: right,
  )[#text(size: 8pt)[Seed: #seed]],

  ..for (a, b) in worksheet-problems {
    (
      table.cell[
        #multiplication(a, b, (a*b), answer: false)
      ],
    )
  }
)

#pagebreak()

= Answers

#table(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  rows: (auto, 1fr),
  column-gutter: 0pt,
  inset: (top: 7pt, right: 10pt, left:10pt, bottom: 5pt),

  table.cell(
    inset: 4pt, 
    fill: black, 
    text(size: 11pt, fill: white, weight: "bold")[#title]
  ),

  table.cell(
    stroke: (
      right: none,
      top: none,
    ),
    colspan: 7
  )[#subtitle],

  table.cell(
    stroke: (
      left: none,
      right: none,
      top: none,
    ),
    colspan: 2, 
    align: right,
  )[#text(size: 8pt)[Seed: #seed]],

  ..for (a, b) in worksheet-problems {
    (
      table.cell[
        #multiplication(a, b, (a*b), answer: true)
      ],
    )
  }
)

