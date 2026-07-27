#import sys: inputs
#import "layout_template.typ": header, title-bar

// Compile this file directly (no --input data=...) to use dummy_algebra_data.json
// for layout experiments. The real pipeline in facts_as_algebra.py always
// passes "data", so it's unaffected.
#let data = if "data" in sys.inputs {
  json(bytes(sys.inputs.at("data")))
} else {
  json("dummy_algebra_data.json")
}
#let seed = data.seed
#let title = data.title
#let ws-details = data.ws-details
#let operation = data.operation
#let worksheet-problems = data.problems.map(p => (p.family, p.member, p.reverse, p.unknown))

#set page(
  paper: "us-letter",
  margin: (
    top: 0.35in,
    left: 0.5in,
    right: 0.5in,
    bottom: 1.5in,
  ),
)

#set text(
  font: "Nimbus Sans",
  size: 12pt,
)

// The "known" side of the equation: the operation applied to family/member,
// as a plain number matching the same family/member convention the other
// four templates use (subtraction's family is the subtrahend, division's is
// the divisor) so the same fact_families.get_facts pairs work everywhere.
#let known-value(family, member) = (
  if operation == "addition" { family + member }
  else if operation == "subtraction" { member }
  else if operation == "multiplication" { family * member }
  else if operation == "division" { member }
)

// The value `unknown` solves to.
#let solved-value(family, member) = (
  if operation == "addition" { member }
  else if operation == "subtraction" { family + member }
  else if operation == "multiplication" { member }
  else if operation == "division" { family * member }
)

// The side of the equation containing the unknown, built from the operation.
// `unknown` is a plain string (from Python, one letter per problem), so math
// mode would otherwise show it upright like a number; math.italic() matches
// how a literal variable like `x` typed directly in math source renders.
#let unknown-side(family, unknown) = (
  if operation == "addition" { $#math.italic(unknown) + #family$ }
  else if operation == "subtraction" { $#math.italic(unknown) - #family$ }
  else if operation == "multiplication" { $#family#math.italic(unknown)$ }
  else if operation == "division" { $display(#math.italic(unknown) / #family)$ }
)

#let algebra-equation(family, member, reverse, unknown, answer: false) = {
  let lhs = if reverse { known-value(family, member) } else { unknown-side(family, unknown) }
  let rhs = if reverse { unknown-side(family, unknown) } else { known-value(family, member) }

  stack(
    dir: ttb,
    spacing: 0.3em,
    align(center)[$#lhs = #rhs$],
    if answer {
      align(center)[
        #text(fill: red, weight: "bold")[$#math.italic(unknown) = #solved-value(family, member)$]
      ]
    },
  )
}

// BEGINNING OF DOCUMENT CONTENT

// A fixed (not 1fr) row height so each problem keeps genuine blank room to
// work underneath it no matter how many problems are on the sheet — 1fr rows
// just divide the page evenly, so they shrink again as count grows. If the
// sheet doesn't fit in this much space per row, it overflows onto more pages
// instead of cramming rows together.
#let algebra-row-height = 2.3cm

#let problem-grid = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    rows: (1fr),
    // rows: (algebra-row-height,),
    column-gutter: 0pt,
    align: (center + top),
    inset: (y: 10pt),

    ..for (family, member, reverse, unknown) in worksheet-problems {
      (
        table.cell[
          #algebra-equation(family, member, reverse, unknown, answer: false)
        ],
      )
    }
  )
}

#let answer-grid = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    rows: (1fr),
    // rows: (algebra-row-height,),
    column-gutter: 0pt,
    align: (center + top),
    inset: (y: 10pt),

    ..for (family, member, reverse, unknown) in worksheet-problems {
      (
        table.cell[
          #algebra-equation(family, member, reverse, unknown, answer: true)
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
