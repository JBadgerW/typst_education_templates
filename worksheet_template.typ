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

#import "worksheet-headers.typ": first-page-header
#import "question-env.typ": question, parts, choices

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

#question[

Factor completely: $display(x^2 + 7x + 12)$

#choices(
  arrangement: "grid",
  [$(x + 4)(x - 3)$],
  [$(x - 2)(x + 1)$],
  [$(x - 1)(x + 8)$],
  [None of the above],
  [Oh, why not have another?],
  //[And another?]
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
