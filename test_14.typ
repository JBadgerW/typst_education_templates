#import "worksheet-headers.typ": first-page-header
#import "question-env.typ": question, parts, choices

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

#let class-name = "Advanced Math"
#let worksheet-title = "Test 14"
#let version = "1"


// ==================================================
// WORKSHEET CONTENT
// ==================================================
#first-page-header(class-name, worksheet-title, version: version)

// ============================================================
//  Advanced Math — Test 14 — Questions in Typst
//  Paste each question block into your Typst template.
//  Math is written in Typst math mode: $...$ for inline,
//  $ ... $ (with spaces) for display.
// ============================================================


// -- Question 1 ----------------------------------------------
#question(space-below: 5em)[
Kathy was traveling $d$ miles to Miami at $n$ miles per hour and arrived
3 hours late for the beach party. How fast should she have traveled to
have arrived on time?
]


// -- Question 2 ----------------------------------------------
#question(space-below: 5em)[
Ricky and his six sons sat around a circular table. How many seating
arrangements were possible?
]


// -- Question 3 ----------------------------------------------
#question(space-below: 5em)[
Sam flew a distance of 500 miles at a normal speed. On the trip back
(also 500 miles) Sam doubled the speed of the plane. How fast did Sam
fly on the trip back if the total traveling time was 5 hours?
]


// -- Question 4 ----------------------------------------------
#question(space-below: 5em)[
How many distinguishable permutations can be formed from the letters
in the word _sassafras_?
]


// -- Question 5 ----------------------------------------------
#question(space-below: 5em)[
Complete the square to graph $y = x^2 - 4x + 3$.
]


// -- Questions 6 and 7: Solve for $x$ -----------------------
#question(space-below: 5em)[
]

// -- Question 6 ----------------------------------------------
#question(space-below: 5em)[
$2 ln 1 + 2 ln 5 = ln(x + 3)$
]


// -- Question 7 ----------------------------------------------
#question(space-below: 5em)[
$log_6 18x - 3 log_6 3 = 1$
]


// -- Question 8 ----------------------------------------------
#question(space-below: 5em)[
The wheels of the mountain bike have a diameter of 26 inches and are
revolving at 60 radians per minute. What is the linear velocity of the
mountain bike in feet per hour?
]


// -- Question 9 ----------------------------------------------
#question(space-below: 5em)[
#enum(
  [Write 6600 as 10 raised to a power.],
  [Write 6600 as $e$ raised to a power.],
  numbering: "(a)",
)
]


// -- Question 10 ---------------------------------------------
#question(space-below: 5em)[
Let $f(x) = sqrt(x)$ and $g(x) = sqrt(x) - 5$. Which of the following
statements is true?

#enum(
  [The graph of $g$ is the graph of $f$ translated five units to the right.],
  [The graph of $g$ is the graph of $f$ translated five units to the left.],
  [The graph of $g$ is the graph of $f$ translated five units up.],
  [The graph of $g$ is the graph of $f$ translated five units down.],
  numbering: "A.",
)
]


// -- Question 11 ---------------------------------------------
#question(space-below: 5em)[
Ling had $a$ artisans who worked $h$ hours to get $c$ crafts made.
Then $m$ artisans went on vacation. How many hours would it take the
remaining artisans to make $d$ crafts?
]


// -- Question 12 ---------------------------------------------
#question(space-below: 5em)[
Adrian went to the fruit store because they were selling $p$ pears for
$c$ cents. When he arrived, the store announced a special of 5 cents
less on each pear. How many pears could Adrian now buy for four dollars?
]


// -- Question 13 ---------------------------------------------
#question(space-below: 5em)[
Write the equation of the following sinusoid:

#figure(
  // Replace this block with your Typst canvas/cetz drawing,
  // or insert an image of the graph.
  // Key features read from the graph:
  //   maximum = 2, minimum = -14, midline D = -6
  //   amplitude A = 8, period T = 360°, so B = 1
  //   graph appears to be a standard cosine shape shifted down
  rect(width: 8cm, height: 4cm, stroke: 0.5pt),
  caption: [Sinusoid graph (see original test)],
)
]

// Note: the graph shows max = 2, min = -14, period = 360°,
// midline at y = -6, with the shape of a cosine.
// Equation: $ y = 8 cos(theta) - 6 $


// -- Question 14 ---------------------------------------------
#question(space-below: 5em)[
Find the area of this triangle.

#figure(
  // Replace with your Typst canvas/cetz drawing.
  // Triangle with two known sides and included angle:
  //   side a = 102 ft, side b = 128 ft, included angle C = 50°
  rect(width: 5cm, height: 4cm, stroke: 0.5pt),
  caption: [Triangle: two sides 102 ft and 128 ft, included angle 50°],
)
]

// Area formula: $ A = 1/2 a b sin(C) $
// $ A = 1/2 (102)(128) sin(50°) $


// -- Question 15 ---------------------------------------------
#question(space-below: 5em)[
Find the area of the segment bounded by an arc of measure $60°$ and
the chord joining the endpoints of the arc in a circle of radius 8 feet.
]


// -- Question 16 ---------------------------------------------
#question(space-below: 5em)[
The latitude of the U.S. Embassy is $48°$ north of the equator. If the
diameter of the earth is 7920 miles, how far is the U.S. Embassy from
the equator?
]


// -- Question 17 ---------------------------------------------
#question(space-below: 5em)[
Factor $x^2 - 7x + 13$ over the set of complex numbers.
]


// -- Question 18 ---------------------------------------------
#question(space-below: 5em)[
Find the equation of the line equidistant from the points $(3, 5)$ and
$(-5, -5)$. Write the equation in double-intercept form.
]


// -- Questions 19 and 20: Solve for $0° <= theta < 360°$ ----

// -- Question 19 ---------------------------------------------
#question(space-below: 5em)[
$ 3 cot(theta / 2) - sqrt(3) = 0 $
]


// -- Question 20 ---------------------------------------------
#question(space-below: 5em)[
$ 2 cos(3 theta) - sqrt(2) = 0 $
]


