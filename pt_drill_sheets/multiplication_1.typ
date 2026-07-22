#import sys: inputs

#let data = json(bytes(sys.inputs.at("data")))
#let seed = data.seed
#let title = data.title
#let subtitle = data.subtitle
#let worksheet-problems = data.problems.map(p => (p.a, p.b))

#set page(
  paper: "us-letter",
  margin: (
    top: 0.5in,
    left: 0.5in,
    right: 0.5in,
    bottom: 0.85in, //  Why on earth does 0.85in = 0.5in? 
  ) 
)

#set text(
  // font: "New Computer Modern",
  // font: "Helvetica Neue",
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

  [], if answer { [#text(fill: red)[#product]] } else { [] },
)

// BEGINNING OF DOCUMENT CONTENT
//
// Name and Date header
#grid(
  columns: (1fr, auto),
  column-gutter: 0pt,
  [Name #answer-blank(3in)],
  align(right)[Date #answer-blank(3.5cm)],
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

