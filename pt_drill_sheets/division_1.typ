#import sys: inputs

#let data = json(sys.inputs.at("data"))
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

// This works best with 'Nimbus Sans' or 'Helvetica Neue'
// but will also work with Typst's default 'Libertinus Serif'
#let division(dividend, divisor, quotient, answer: false) = {
  table(
    columns: (auto, auto),
    stroke: 0.0em + red,
    inset: 0.12em,
    align: right + top,
    [],
    [#if answer { [#quotient] } else { [] }],
    table.cell(inset: (top: 0.28em))[#divisor],
    [
      #grid(
        columns: (auto, auto),
        grid.cell(
          inset: (top: 0.1175em)
        )[#h(-0.15em)\u{27CC}],

        grid.cell(
          stroke: (top: 0.053em), 
          inset: (top: 0.155em)
        )[#dividend]
      )
    ]
  )
}

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
    text(size: 11pt, fill: white, weight: "bold")[#title]
  ),

  table.cell(
    stroke: (
      right: none,
      top: none,
    ),
    colspan: 7,
    align: left + horizon,
    inset: (bottom: 5pt),
  )[#subtitle],

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
    text(size: 11pt, fill: white, weight: "bold")[#title]
  ),

  table.cell(
    stroke: (
      right: none,
      top: none,
    ),
    colspan: 7,
    align: left + horizon,
    inset: (bottom: 5pt),
  )[#subtitle],

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

