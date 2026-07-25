#set page(
  paper: "us-letter",
  margin: (
    top: 0.35in,
    left: 0.5in,
    right: 0.5in,
    bottom: 0.5in, 
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

#table(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  align: center,

  [Monday],
  [Tuesday],
  [Wednesday],
  [Thursday],
  [Friday],
  [Saturday],

  table.cell(align: left)[Time:], [], [], [], [], [],
  table.cell(align: left)[\#C:], [], [], [], [], [],
  table.cell(align: left)[\#X:], [], [], [], [], [],

  table.cell(align: left)[Time:], [], [], [], [], [],
  table.cell(align: left)[\#C:], [], [], [], [], [],
  table.cell(align: left)[\#X:], [], [], [], [], [],

  table.cell(align: left)[Time:], [], [], [], [], [],
  table.cell(align: left)[\#C:], [], [], [], [], [],
  table.cell(align: left)[\#X:], [], [], [], [], [],
)
