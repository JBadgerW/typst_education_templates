// The point of this is to incorporate in a single file the modular
// imports that I eventually will bundle in a package. Right now I
// don't want to bother with all that. So this file should work the
// way I want it to without any local package installs.

//#import "worksheet-headers.typ": first-page-header
//#import "question-env.typ": question, parts, choices

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

// Question Environment definitions
// Usage: #question(points: which is optional)[body of question]
//        #parts[] An inner environment for parts of a question
//        #choices(arrangement: stacked, linear, grid)[] for 
//          multiple choice questions

// Question counter
#let qnum = counter("question")

// Question environment
#let question(points: none, space-below: 1fr, body) = {
  qnum.step()

  block(
    below: space-below,
  )[
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.5em,

      [
        #context qnum.display("1.")  
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
    // chunk into pairs, padding with empty if odd
    let pairs = range(0, labeled.len(), step: 2).map(i => {
      let a = labeled.at(i)
      let b = if i + 1 < labeled.len() { labeled.at(i + 1) } else { none }
      (a, b)
    })

    stack(
      dir: ttb,
      spacing: 1em,
      ..pairs.map(((a, b)) =>
        grid(
          columns: (1fr, 1fr),
          [#a.at(0) #h(0.25em) #a.at(1)],
          if b != none [#b.at(0) #h(0.25em) #b.at(1)] else [],
        )
      )
    )
  } else {
    panic("choices: unknown arrangement '" + arrangement + "'. Use vertical, linear, or grid.")
  }
}

#let first-page-header(class-name, worksheet-title, version: "1") = [
  #v(-0.25in)
  #grid(
    columns: (1fr, auto),
    column-gutter: 0pt,
    row-gutter: 1.4em,

    [#class-name],
    align(right)[Name #answer-blank(7cm)],

    [#set text(size: 15pt, weight: "bold"); #worksheet-title],
    align(right)[Date #answer-blank(3.5cm) Ver: #version],
  )
  #v(1em)
]

// ==================================================
// DOCUMENT VARIABLES
// ==================================================

#let class-name = "Algebra II"
#let worksheet-title = "Factoring Quadratics and Solving Linear Equations"
#let version = "1"


// ==================================================
// WORKSHEET CONTENT
// ==================================================
#first-page-header(class-name, worksheet-title, version: version)

#question(space-below: 5em)[

Factor completely: $display(x^2 + 7x + 12)$

#choices(
  //arrangement: "grid",
  [$(x + 4)(x - 3)$],
  [$(x - 2)(x + 1)$],
  [$(x - 1)(x + 8)$],
  [
    When in the course of human events it becomes necessary
    for one people to dissolve the political bands that have 
    joined them to another and assume among the powers of the
    earth that separate and equal station to which the laws of
    Nature and Nature's God entitle them....
  ],
  //[Oh, why not have another?],
  //[And another?]
)
//#v(2.5cm)

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
