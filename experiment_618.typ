#import "worksheet-headers.typ": first-page-header
#import "question-env.typ": question, parts, choices, fillin, answer-blank

#set page(
  paper: "us-letter",
  margin: 0.75in
)

#set text(
  font: "New Computer Modern",
  // font: "Linux Libertine O",
  // font: "Times New Roman",
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
// WORKSHEET CONTENT
// ==================================================
#first-page-header(class-name, worksheet-title, version: version)

#question(space-below: 5em)[

Factor completely: $display(x^2 + 7x + 12)$

#choices(
  arrangement: "vertical",
  [$(x + 4)(x - 3)$],
  [$(x - 2)(x + 1)$],
  [$(x - 1)(x + 8)$],
  // [
  //   When in the course of human events it becomes necessary
  //   for one people to dissolve the political bands that have 
  //   joined them to another and assume among the powers of the
  //   earth that separate and equal station to which the laws of
  //   Nature and Nature's God entitle them....
  // ],
  // [Oh, why not have another?],
  [And another?]
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

#question()[When in the course of #fillin(answers: false)[human] events, it becomes...
  #choices(
    arrangement: "linear",
    [philosophical],
    [human],
    [historical],
    [earthly],
  )
]


== Matching Lists

#emph()[Match each definition on the left with its term on the right.]

#v(1em)

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    #question(answer-line: 1.25cm)[Capital of Assyria]
  
    #question(answer-line: 1.25cm)[Inventors of the airplane]

    #question(answer-line: 1.25cm)[Longest river in the world.]

    #question(answer-line: 1.25cm)[First Roman emperor]

    #question(answer-line: 1.25cm)[Speed of light]
  ],
  [
    #enum(
    tight: false,
    numbering: "A.",
      [_c_],

      [Nile],

      [Caesar Augustus],

      [Nineveh],

      [Wright Brothers],

    )
  ]
)

== Write in with Word bank

#emph()[Write the correct answer on the line given. Use the given word bank.]

#v(1em)

#grid(
  columns: (1fr, 1fr, 1fr),
  [
    _c_

    Caesar Augustus

  ],
  [
    Nile
    
    Nineveh
  ],
  [
    Wright Brothers
  ],
)

#v(1em)

#question(answer-line: 3in)[Capital of Assyria]

#question(answer-line: 3in)[Inventors of the airplane]

#question(answer-line: 3in)[Longest river in the world]

#question(answer-line: 3in)[First Roman emperor]

#question(answer-line: 3in)[Speed of light]
