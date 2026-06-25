#import "@preview/suiji:0.5.1": *
#import sys: inputs

#let seed = int(sys.inputs.at("seed", default: "28056"))

#let rng = gen-rng(
  seed
)

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
  font: "Helvetica Neue",
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

#let division(dividend, divisor, quotient, answer: false) = table(
  columns: (auto, auto),
  align: (right, right),
  stroke: none,
  inset: 2pt,

  [], if answer { [#quotient] } else { [] },
  [#divisor], 
  table.cell(
    stroke: (left: 1pt, top: 1pt),
  )[#dividend]
)

#let problems = (
  ..for a in range(1, 13) {
    for b in range(1, 13) {
      ((a, b),)
    }
  },
)

#let shuffled-state = shuffle(rng, problems)

#let worksheet-problems = shuffled-state.at(1).slice(0, 90) 

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
  inset: (top: 7pt, right: 4pt, left:4pt, bottom: 5pt),

  table.cell(
    inset: 4pt, 
    fill: black, 
    text(size: 11pt, fill: white, weight: "bold")[90 Facts]
  ),

  table.cell(
    stroke: (
      right: none,
      top: none,
    ),
    colspan: 7
  )[Multiply up to 12],

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
        #division((a*b), b, a, answer: false)
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
    text(size: 11pt, fill: white, weight: "bold")[90 Facts]
  ),

  table.cell(
    stroke: (
      right: none,
      top: none,
    ),
    colspan: 7
  )[Multiply up to 12],

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
        #division((a*b), b, a, answer: true)
      ],
    )
  }
)

