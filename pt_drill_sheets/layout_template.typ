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
    top: 0.35in,
    left: 0.5in,
    right: 0.5in,
    bottom: 1.5in, //  Why does 1.5in == 0.5? 
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

  [], if answer {[
    #text(
      fill: red, 
      weight: "bold"
    )[#product]
  ]} else { [] },
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
        column-gutter: (0.25cm),
        stroke: none,
        align: bottom,

        [Timing: #answer-blank(1.5cm) sec],
        [\# correct #answer-blank(1.5cm) /min],

        [],
        [\# wrong #answer-blank(1.5cm) /min]
      )
    }
  )
)

#let title-bar = table(
  columns: (auto, 1fr, auto),
  stroke: none,
  table.cell(
    inset: 4pt,
    fill: black,
    stroke: 1pt,
    text(size: 11pt, fill: white, weight: "bold")[#title]
  ),
  [#subtitle],
  [#text(size: 8pt)[Seed: #seed]]
)

#let problem-grid = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    rows: (1fr, 1fr),
    column-gutter: 0pt,
    inset: (top: 7pt, right: 10pt, left:10pt, bottom: 5pt),

     ..for (a, b) in worksheet-problems {
      (
        table.cell[
          #multiplication(a, b, (a*b), answer: false)
        ],
      )
    }
  )
}

#let answer-grid = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    rows: (1fr),
    column-gutter: 0pt,
    inset: (top: 7pt, right: 10pt, left:10pt, bottom: 5pt),

    ..for (a, b) in worksheet-problems {
      (
        table.cell[
          #multiplication(a, b, (a*b), answer: true)
        ],
      )
    }
  )
}

#stack(
  dir: ttb,
  spacing: 0.3cm,
  header,
  stack(
    dir: ttb,
    spacing: 0cm,
    title-bar,
    problem-grid  
  )
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
    answer-grid
  )
)

