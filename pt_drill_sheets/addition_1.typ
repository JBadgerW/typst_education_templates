#import sys: inputs
#import "layout_template.typ": header, title-bar

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
#let worksheet-problems = data.problems.map(p => (p.a, p.b))

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

#let addition(a, b, sum, answer: false) = table(
  columns: (auto, auto),
  align: (right, right),
  stroke: none,

  [], [#a],
  [$+$], [#b],

  table.hline(),

  [], if answer { [#text(fill: red, weight: "bold")[#sum]] } else { [] },
)


// BEGINNING OF DOCUMENT CONTENT

#let problem-grid = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    rows: (1fr, 1fr),
    column-gutter: 0pt,
    align: (top + center),

    ..for (a, b) in worksheet-problems {
      (
        table.cell[
          #addition(a, b, (a + b), answer: false)
        ],
      )
    }
  )
}

#let answer-grid = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    rows: 1fr,
    column-gutter: 0pt,
    align: (top + center),

    ..for (a, b) in worksheet-problems {
      (
        table.cell[
          #addition(a, b, (a + b), answer: true)
        ],
      )
    }
  )
}

// LAYOUT

// Problems

#stack(
  dir: ttb,
  spacing: 0.3cm,
  header,
  stack(
    dir: ttb,
    spacing: 0cm,
    title-bar,
    problem-grid,
  ),
)

#pagebreak()

// Answers

#stack(
  dir: ttb,
  spacing: 1.3cm,
  [= Answers],
  stack(
    dir: ttb,
    spacing: 0cm,
    title-bar,
    answer-grid,
  ),
)


