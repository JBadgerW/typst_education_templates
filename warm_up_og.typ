// WORKSHEET BASIC INFORMATION
#let ws-class         = [Algebra 1]
#let ws-title         = [Evaluating algebraic expressions]
#let ws-version       = [32]
#let ws-instructions  = [Evaluate each expression and circle your answer.]

#import "question-env.typ": question

#let worksheet-content = [
  #question(space-below: 1fr)[
    $6 + j k + k^3$ #h(1fr) when $j = 6$ and $k = 6$
  ]

  #question(space-below: 1fr)[
    $f^3 + 6 g - 6 h$ #h(1fr) when $f = 5$, $g = 6$, and $h = 4$
  ]

  #question(space-below: 1fr)[
    $7 a + 2 b - 1 + c^3$ #h(1fr) when $a = 4$, $b = 8$, and $c = 4$
  ]

  #question(space-below: 1fr)[
    $2 c - 3 d + 17$ #h(1fr) when $c = 7$ and $d = 10$
  ]

  #question(space-below: 1fr)[
    $display((c)/(2) - 10 + (32)/(d))$ #h(1fr) when $c = 10$ and $d = 8$
  ]

  #question(space-below: 1fr)[
    $8 + j k + k^3$ #h(1fr) when $j = 3$ and $k = 4$
  ]

]

#let answers-content = [
  #question()[5]
  #question()[10]
  #question()[15]
  #question()[20]
]

#set page(
paper: "us-letter",
flipped: true,
margin: 1cm,
)

#set text(
  size: 12pt,
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
    heading(level: 1)[#ws-title],
    [Ver. #ws-version],
  )
]

#let instructions = [
  #emph[#ws-instructions]
]

// -- Possible different header configuration
// I don't know what it is, but I don't like this configuration for these half-
// page worksheets. I think everything just feels too crowded. The advantage is
// that you get the name of the class at the top, but I'm just not sure.
#let class-name = [
  #grid(
    columns: (1fr, auto),
    [
      #ws-class
    ],
    [
      Name #answer-blank(2in)
    ],
  )
]

#let title-date-version = [
  #grid(
    columns: (1fr, auto, auto),
    [
      #text(size: 14pt, weight: "bold")[
        #ws-title 
      ]
    ],
    [
      Date #answer-blank(1in)
    ],
  )
]

// #let worksheet-header = stack(
//   spacing: 0.5cm,
//   class-name,
//   stack(
//     spacing: 0.3cm,
//     title-date-version,
//     instructions,
//   )
// )

// -- END OF DIFFERENT HEADER CONFIGURATION

#let worksheet-header = stack(
  spacing: 0.3cm,
  name-date,
  stack(
    spacing: 0.4cm,
    title-version,
    instructions,
  )
)

#let worksheet-page() = [
  #counter("question").update(0)

  #stack(
    spacing: 0.7cm,
    worksheet-header,
    worksheet-content,
  )
]

#let answer-page() = [
  #counter("question").update(0)

  #stack(
    spacing: 0.7cm,
    heading(level: 1)[#ws-title],
    title-version, 
  )
]

// #let answers-heading = [
//   #grid(
//     [#text()]
//   )
// ]

#grid(
  columns: (1fr, 1fr),
  gutter: 2cm,
  [#worksheet-page()],
  [#worksheet-page()],
)

#pagebreak()

#grid(
  columns: (1fr, 1fr),
  gutter: 2cm,
  [#answer-page()],
  [#answer-page()],
)
