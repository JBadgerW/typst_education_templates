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

#let division(dividend, divisor, quotient, answer: false) = {
  table(
    columns: (auto, auto),
    stroke: none,
    inset: 0.08em,
    align: right + top,
    [],
    [#if answer { [#quotient] } else { [] }],
    table.cell(inset: (top: 0.2em))[#divisor],
    [
      #grid(
        columns: (auto, auto),
        stroke: (top: 0.06em),
        inset: (top: 0.05em),
        [)],//[#h(-0.03em))],
        grid.cell(inset: (top: 0.12em))[#dividend]
      )
    ]
  )
}

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
  inset: (bottom: 30pt),
  align: center + bottom,

  table.cell(
    inset: 4pt, 
    fill: black, 
    align: center + horizon,
    text(size: 11pt, fill: white, weight: "bold")[90 Facts]
  ),

  table.cell(
    stroke: (
      right: none,
      top: none,
    ),
    colspan: 7,
    align: left + horizon,
    inset: (bottom: 5pt),
  )[Divide up to 144 by 12],

  table.cell(
    stroke: (
      left: none,
      right: none,
      top: none,
    ),
    colspan: 2, 
    align: right + horizon,
    inset: (bottom: 5pt),
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
  inset: (bottom: 30pt),
  align: center + bottom,


  table.cell(
    inset: 4pt, 
    fill: black, 
    align: center + horizon,
    text(size: 11pt, fill: white, weight: "bold")[90 Facts]
  ),

  table.cell(
    stroke: (
      right: none,
      top: none,
    ),
    colspan: 7,
    align: left + horizon,
    inset: (bottom: 5pt),
  )[Divide up to 144 by 12],

  table.cell(
    stroke: (
      left: none,
      right: none,
      top: none,
    ),
    colspan: 2, 
    align: right + horizon,
    inset: (bottom: 5pt),
  )[#text(size: 8pt)[Seed: #seed]],

  ..for (a, b) in worksheet-problems {
    (
      table.cell[
        #division((a*b), b, a, answer: true)
      ],
    )
  }
)

