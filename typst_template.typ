#set page(
  paper: "us-letter",
  margin: 0.75in
)

#set text(
  font: "New Computer Modern",
  size: 12pt,
)

#set par(
  justify: false,
  leading: 0.65em,
)


// ==================================================
// DOCUMENT VARIABLES
// ==================================================

#let class-name = "Algebra II"
#let worksheet-title = "Factoring Quadratics and Solving Linear Equations"

#let version = "1"


// ==================================================
// HELPER FUNCTIONS
// ==================================================

// Inline blank line
#let blank(width) = box(
  width: width,
  inset: 0pt,
  stroke: (bottom: 0.7pt),
)

// Question counter
#let qnum = counter("question")

// Question environment
#let question(points: none, body) = {
  qnum.step()

  block(
    below: 1.5em,
  )[
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.5em,

      [
        #context{
          qnum.display("1.")  
        }
      ],

      [
        #body
      ],

      [
        #if points != none [
          (#points pts)
        ]
      ],
    )
  ]
}


// Parts environment
#let parts(..items) = {
  stack(
    dir: ttb,
    spacing: 0.75em,

    ..items.pos().enumerate().map(((i, item)) => [
      #numbering("(a)", i + 1)
      #h(0.5em)
      #item
    ])
  )
}

// choices environment for multiple choice questions
#let choices(arrangement: "vertical", ..items) = {
  let labeled = items.pos().enumerate().map(((i, item)) => (
    numbering("A.", i + 1),
    item,
  ))

  if arrangement == "vertical" {
    // Original behavior: one choice per line
    stack(
      dir: ttb,
      spacing: 1em,
      ..labeled.map(((label, item)) => [
        #label #h(0.25em) #item
      ])
    )

  } else if arrangement == "linear" {
    // All choices on one line
    labeled.map(((label, item)) => [
      #label #h(0.25em) #item #h(1.5em)
    ]).join()

  } else if arrangement == "grid" {
    // 2×2 grid: A B on top row, C D on bottom
    let pairs = (
      labeled.slice(0, 2),
      labeled.slice(2, 4),
    )
    stack(
      dir: ttb,
      spacing: 1em,
      ..pairs.map(row =>
        grid(
          columns: (1fr, 1fr),
          ..row.map(((label, item)) => [
            #label #h(0.25em) #item
          ])
        )
      )
    )
  }
}

// ==================================================
// HEADER
// ==================================================

#v(-0.25in)

#grid(
  columns: (1fr, auto),
  column-gutter: 0pt,
  row-gutter: 1.4em,
  
  // Top row
  [
    #class-name
  ],
  align(right)[
    Name #blank(7cm)
  ],
  
  // Bottom row
  [
    #set text(size: 15pt, weight: "bold"); #worksheet-title
  ],
  align(right)[
    Date #blank(3.5cm) Ver: #version
  ],
)

#v(1em)


// ==================================================
// WORKSHEET CONTENT
// ==================================================

#question[

Factor completely: $display(x^2 + 7x + 12)$

#choices(
  //arrangement: "grid",
  [$(x + 4)(x - 3)$],
  [$(x - 2)(x + 1)$],
  [$(x - 1)(x + 8)$],
  [None of the above],
)
#v(2.5cm)

]


#question[

Solve the following equations.

#parts(

  [$2x + 5 = 17$

    #v(2cm)
  ],

  [
    $display(3(x - 2) = 21)$

    #v(2cm)
  ],

  [
    $display((x^2 - 9) / (x - 3) = 0)$

    #v(2cm)
  ],
)

]


#question[

A rectangle has length
$display(x + 3)$
and width
$display(x - 2)$.

//#v(0.75em)

Write an expression for the area and simplify.

#v(4cm)

]


#question(points: 5)[

Graph the following function. $y = x^2 - 4x + 3$
]


#question(points: 3)[

Evaluate:

#v(0.75em)

#parts(

  [
    $display(sum_(i=1)^5 i)$
    #v(1fr)
  ],

  [
    //#v(2em)
    $display(binom(5, 2) / 2^5)$
    #v(1fr)
  ],

  [
    $display(integral_0^1 x^2 dif x)$
  ],
)

]
