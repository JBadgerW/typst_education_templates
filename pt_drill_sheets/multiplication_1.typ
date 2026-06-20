#set page(
  paper: "us-letter",
  margin: 0.5in
)

#set text(
  font: "New Computer Modern",
  // font: "Helvetica Neue",
  size: 11pt,
)


#let answer-blank(width) = box(
  width: width,
  inset: 0pt,
  stroke: (bottom: 0.7pt),
)


// Name and Date header
#grid(
  columns: (1fr, auto),
  column-gutter: 0pt,
  [Name #answer-blank(3in)],
  align(right)[Date #answer-blank(3.5cm)],
)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  column-gutter: 0pt,
  []
)
