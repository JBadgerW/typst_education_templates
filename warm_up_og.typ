#let ws-title         = [Solving one-step equations]
#let ws-version       = [32]
#let ws-instructions  = [Solve each equation for $y$.]

#set page(
paper: "us-letter",
flipped: true,
margin: 1cm,
)

#set text(
  size: 11pt,
  font: "New Computer Modern",
)

#let answer-blank(width) = box(
  width: width,
  inset: 0pt,
  stroke: (bottom: 0.7pt),
)

#let name-date = [
  #grid(
    columns: (1fr, auto),
    // stroke: 1pt + red,
    [
      Name #answer-blank(2in)
    ],
    [
      Date #answer-blank(1in) 
    ],
  )
]

#let title-version = [
  #grid(
    columns: (1fr, auto),
    // stroke: 1pt + blue,
    [
      #text(size: 14pt, weight: "bold")[
        #ws-title 
      ]
    ],
    [
      Ver. #ws-version
    ],
  )
]

#let instructions = [
  _ #ws-instructions _
]

#let worksheet-header = stack(
  spacing: 0.3cm,
  name-date,
  stack(
    spacing: 0.3cm,
    title-version,
    instructions,
  )
)


#grid(
  columns: (1fr, 1fr),
  gutter: 2cm,
  // stroke: 1pt + red,
  [#worksheet-header],
  [#worksheet-header],
)
// #let assignment-width = 5.1in
// #let assignment-height = 7.7in
//
// // --------------------------------------------------
// // QUESTION DATA
// // --------------------------------------------------
//
// #let warmup005 = (
// title: "Warm Up 005",
// directions: "Evaluate.",
// questions: (
// "$8 + jk + k^2$ when $j = 5$ and $k = 5$",
// "$f^3 + 3g - 5h$ when $f = 1$, $g = 1$, and $h = 2$",
// "$5a + 7b - 6 + c^2$ when $a = 4$, $b = 5$, and $c = 7$",
// "$8c - 7d + 19$ when $c = 7$ and $d = 10$",
// "$frac(c)(4) - 7 + frac(49)(d)$ when $c = 4$ and $d = 7$",
// "$14 + jk + k^3$ when $j = 5$ and $k = 6$",
// "$f^2 + 6g - 7h$ when $f = 6$, $g = 2$, and $h = 8$",
// "$7a + 3b - 13 + c^3$ when $a = 4$, $b = 7$, and $c = 8$",
// ),
// answers: (
// "58",
// "-6",
// "78",
// "5",
// "1",
// "260",
// "-38",
// "526",
// ),
// )
//
// #let warmup006 = (
// title: "Warm Up 006",
// directions: "Evaluate.",
// questions: (
// "$6 + jk + k^3$ when $j = 6$ and $k = 6$",
// "$f^3 + 6g - 6h$ when $f = 5$, $g = 6$, and $h = 4$",
// "$7a + 2b - 1 + c^3$ when $a = 4$, $b = 8$, and $c = 4$",
// "$2c - 3d + 17$ when $c = 7$ and $d = 10$",
// "$frac(c)(2) - 10 + frac(32)(d)$ when $c = 10$ and $d = 8$",
// "$8 + jk + k^3$ when $j = 3$ and $k = 4$",
// "$f^2 + 4g - 5h$ when $f = 6$, $g = 1$, and $h = 1$",
// "$3a + 4b - 16 + c^2$ when $a = 3$, $b = 2$, and $c = 6$",
// ),
// answers: (
// "258",
// "137",
// "87",
// "-1",
// "-1",
// "84",
// "35",
// "35",
// ),
// )
//
// // --------------------------------------------------
// // HEADER COMPONENT
// // --------------------------------------------------
//
// #let worksheet-header(title, directions) = [
// #align(left)[
// Name #line(length: 2.2in)
// #h(1fr)
// Date #line(length: 1.3in)
// ]
//
// #v(0.15in)
//
// #text(size: 16pt, weight: "bold")[#title]
//
// #v(0.05in)
//
// #emph[#directions]
//
// #v(0.15in)
// ]
//
// // --------------------------------------------------
// // QUESTION COMPONENT
// // --------------------------------------------------
//
// #let question-item(number, body) = block(
// spacing: 0.9em,
// )[
// #number. #body
//
// #v(0.45in)
// ]
//
// // --------------------------------------------------
// // WORKSHEET COMPONENT
// // --------------------------------------------------
//
// #let worksheet(data) = box(
// width: assignment-width,
// height: assignment-height,
// inset: 0.15in,
// )[
// #worksheet-header(
// data.title,
// data.directions,
// )
//
// #for (i, q) in data.questions.enumerate() {
// question-item(i + 1, q)
// }
// ]
//
// // --------------------------------------------------
// // ANSWER KEY COMPONENT
// // --------------------------------------------------
//
// #let answer-key(data) = box(
// width: assignment-width,
// height: assignment-height,
// inset: 0.2in,
// )[
// #text(weight: "bold", size: 14pt)[
// #data.title Answers
// ]
//
// #v(0.2in)
//
// #grid(
// columns: 2,
// gutter: 0.5in,
//
// ```
// ..data.answers.enumerate().map(((i, ans)) => [
//   #strong[(#char("A".codepoint() + i).text).]
//   #h(0.5em)
//   #ans
//   #v(0.25in)
// ])
// ```
//
// )
// ]
//
// // --------------------------------------------------
// // TWO-UP LAYOUT
// // --------------------------------------------------
//
// #let two-up(left, right) = [
// #grid(
// columns: (1fr, 1fr),
// gutter: 0.3in,
//
// ```
// [
//   #left
// ],
//
// [
//   #right
// ],
// ```
//
// )
// ]
//
// // --------------------------------------------------
// // DOCUMENT
// // --------------------------------------------------
//
// #two-up(
// worksheet(warmup005),
// worksheet(warmup005),
// )
//
// #pagebreak()
//
// #two-up(
// worksheet(warmup006),
// worksheet(warmup006),
// )
//
// #pagebreak()
//
// #two-up(
// answer-key(warmup005),
// answer-key(warmup005),
// )
//
// #pagebreak()
//
// #two-up(
// answer-key(warmup006),
// answer-key(warmup006),
// )

