// ─────────────────────────────────────────────────────────────────────────────
//  Final Exam Template
//  ► Completely self-contained — no external imports required.
//  ► Fill in the capitalised placeholders (COURSE NAME, etc.) to customise.
// ─────────────────────────────────────────────────────────────────────────────

// CONTENT STARTS ON LINE 275ish

// ── Document metadata ────────────────────────────────────────────────────────
#let exam-title = "Example Examination"
#let exam-author = "Mr. John Smith"

#set document(
  title:  exam-title,
  author: exam-author,
)

// ── Colour palette ────────────────────────────────────────────────────────────
//  These mirror the study-guide palette so the two documents feel like a pair.

#let accent    = rgb("#1a5c8a")   // deep blue  — section banners, rules
#let sec-col   = rgb("#2e7d52")   // green      — subsection headers
#let box-bg    = rgb("#eef4fb")   // light blue — instruction / note boxes
#let rule-col  = luma(180)        // light grey — header/footer rule

// ── Page layout ───────────────────────────────────────────────────────────────

#set page(
  paper:  "us-letter",
  margin: (top: 1in, bottom: 1in, left: 0.75in, right: 0.75in),

  // Running header — suppressed on page 1 (title block takes that role)
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 9pt, fill: luma(120))
      #grid(
        columns: (1fr, 1fr),
        align(left)[#exam-title],
        align(right)[Page #counter(page).display()],
      )
      #line(length: 100%, stroke: 0.5pt + rule-col)
   ]
  },

  // Footer — page number on page 1 only
  footer: context {
    if counter(page).get().first() == 1 [
      #set text(size: 9pt, fill: luma(120))
      #align(center)[#counter(page).display()]
   ]
  },
)

// ── Base typography ───────────────────────────────────────────────────────────

#set text(font: "Linux Libertine O", size: 11pt)
// #set text(font: "Helvetica Neue", size: 11pt)
#set par(justify: true, leading: 0.65em)
#set heading(numbering: none)

// ── Helper components ─────────────────────────────────────────────────────────

// This is a reformatting of the level 1 header. It can be used by itself, or
// the section-banner() function can use it to display a certain number of points
// to the right.
#show heading.where(level: 1): it => {
  v(30pt, weak: true)
  block(
    width:  100%,
    fill:   accent,
    radius: 6pt,
    inset:  (x: 14pt, y: 10pt),
    below:  14pt,
    sticky: true,
  )[
    #set text(size: 16pt, weight: "bold", fill: white, font: "Helvetica Neue")
    #it
   ]
}

// Large coloured banner — use for major exam sections (Part I, Part II, …)
// It uses header(level: 1), so the counters should all work.
#let section-banner(title, points: none) = {
  if points != none {
    heading(level: 1)[
      #grid(
        columns: (1fr, auto),
        title,
        text(size: 12pt, weight: "regular")[#points pts],
      )
    ]
  } else {
    heading(level: 1)[#title]
  }
}

#show heading.where(level: 2): it => {
  block(
      width:  100%,
      fill:   sec-col,
      radius: 4pt,
      inset:  (x: 12pt, y: 7pt),
      below:  10pt,
      sticky: true,
  )[
    #set text(size: 12pt, weight: "bold", fill: white, font: "Helvetica Neue")
    #it
  ]
}

// Smaller coloured header — use for sub-sections or question groups
#let subsection-banner(title, points: none) = {
  if points != none {
    grid(
      columns: (1fr, auto),
      title,
      text(size: 10pt, weight: "regular")[#points pts],
    )
  } else {
    heading(level: 2)[#title]
  }
}

// Tinted instruction box (matches info-box from the study guide)
#let instruction-box(body) = block(
  width:  100%,
  fill:   box-bg,
  stroke: (left: 4pt + accent),
  radius: (right: 4pt),
  inset:  12pt,
  below:  12pt,
  body,
)

// Answer blank — a labelled underline for short written responses
//   #answer-line("your label here", width: 60%)
#let answer-line(label: none, width: 100%) = {
  v(6pt)
  if label != none [
    #text(size: 10pt, fill: luma(60), weight: "bold")[#upper(label)]
  ]
  box(width: width)[
    #line(length: 100%, stroke: 0.5pt + luma(160))
  ]
  v(4pt)
}

// Multiple blank lines for longer written responses
//   #answer-lines(4)   ← four ruled lines
#let answer-lines(n) = {
  for _ in range(n) {
    v(14pt)
    line(length: 100%, stroke: 0.5pt + luma(160))
  }
  v(6pt)
}

// Question Environment definitions
// Usage: #question(points: which is optional)[body of question]
//        #parts[] An inner environment for parts of a question
//        #choices(arrangement: stacked, linear, grid)[] for 
//          multiple choice questions

#let answer-blank(width) = box(
  width: width,
  inset: 0pt,
  stroke: (bottom: 0.7pt),
)

// Question counter
#let qnum = counter("question")

// Question environment
#let question(points: none, 
  space-below: 2em, 
  answer-line: none,
  renum: none,
  body
) = {
  if renum != none {
    qnum.update(renum - 1)
  }
  qnum.step()

  block(
    below: space-below,
    breakable: false,
  )[
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.5em,

      [
        #context qnum.display("1.")
        #if answer-line != none [
          #answer-blank(answer-line)
        ]
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
        #grid(
          columns: (auto, 1fr),
          [#label #h(0.25em)],
          [#item]
        )
      ])
    )

  } else if arrangement == "linear" {
    [
      #parbreak()
      // All choices on one line
      #labeled.map(((label, item)) => [
        #label #h(0.25em) #item #h(1fr)
      ]).join()
    ]

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
          gutter: 12pt,
          [
            #grid(
              columns: (auto, 1fr),
              [#a.at(0) #h(0.25em)],
              [#a.at(1)],
            ) 
          ],
          if b != none [
            #grid(
              columns: (auto, 1fr),
              [#b.at(0) #h(0.25em)],
              [#b.at(1)],
            ) 
          ] else [],
        )
      )
    )
  } else {
    panic("choices: unknown arrangement '" + arrangement + "'. Use vertical, linear, or grid.")
  }
}

// Point value label (right-aligned, used inline beside questions)
#let pts(n) = h(1fr) + text(size: 9pt, fill: luma(100))[_(#n pt#if n != 1 [s])_]

// ─────────────────────────────────────────────────────────────────────────────
//  PART I Exam begins
// ─────────────────────────────────────────────────────────────────────────────

// CONTENT HERE

= MULTIPLE CHOICE QUESTIONS

#question()[What is the capital of Assyria?
#choices(
[Jerusalem],
[Nineveh],
[Thebes],
[Babylon],
)
]

#question()[Solve for $x$: $2 x + 7 = 19$
#choices(
[$x = 5$],
[$x = 6$],
[$x = 7$],
[$x = 8$],
)
]

#question()[Which character kills Hector in Homer's _Iliad_?
#choices(
[Odysseus],
[Paris],
[Achilles],
[Agamemnon],
)
]

== choices(arrangement: "linear")

#question()[What is the slope of the line through $(2, 3)$ and $(6, 11)$?
#choices(arrangement: "linear",
[$1$],
[$2$],
[$3$],
[$4$],
)
]

== choices(arrangement: "grid")

#question()[Which document begins with the words "We the People"?
#choices(arrangement: "grid",
[The Magna Carta],
[The Declaration of Independence],
[The Constitution of the United States],
[The Federalist Papers],
)
]

#question()[Simplify: $3(2x - 5)$
#choices(arrangement: "grid",
[$6x - 15$],
[$6x - 5$],
[$5x - 15$],
[$6x + 15$],
)
]

#pagebreak()

== Two columns

#columns(gutter: 12pt)[
  #question()[Which Shakespeare play contains the characters Rosencrantz and Guildenstern?
  #choices(
  [Macbeth],
  [Hamlet],
  [King Lear],
  [Julius Caesar],
  )
  ]

  #question()[What is the value of $5^2$?
  #choices(
  [$10$],
  [$15$],
  [$20$],
  [$25$],
  )
  ]

  #question()[Who was the first emperor of Rome?
  #choices(
  [Julius Caesar],
  [Augustus],
  [Nero],
  [Constantine],
  )
  ]

  #question()[Factor: $x^2 - 9$
  #choices(
  [$(x - 3)(x - 3)$],
  [$(x + 3)(x + 3)$],
  [$(x - 3)(x + 3)$],
  [$(x - 9)(x + 1)$],
  )
  ]

  #colbreak()

  #question()[Which of the following is a prime number?
  #choices(
  [$21$],
  [$27$],
  [$29$],
  [$35$],
  )
  ]

  #question()[What literary device gives human characteristics to non-human things?
  #choices(
  [Metaphor],
  [Irony],
  [Personification],
  [Allusion],
  )
  ]

  #question()[What is the area of a rectangle with length $8$ and width $5$?
  #choices(
  [$13$],
  [$26$],
  [$40$],
  [$80$],
  )
  ]

  #question()[Which civilization built the Parthenon?
  #choices(
  [Romans],
  [Egyptians],
  [Greeks],
  [Persians],
  )
  ]
]

== And back to only 1 column

#question()[Convert $0.75$ to a fraction.
#choices(
[$1/2$],
[$2/3$],
[$3/4$],
[$4/5$],
)
]

#question()[In _Romeo and Juliet_, which family is Romeo part of?
#choices(
[Capulet],
[Montague],
[Lancaster],
[York],
)
]

#question()[What is the solution to $x^2 = 49$?
#choices(
[$7$],
[$-7$],
[$7$ and $-7$],
[$0$],
)
]

#question()[Which war was fought between the North and South regions of the United States?
#choices(
[The Revolutionary War],
[The Civil War],
[World War I],
[The War of 1812],
)
]

#question()[What is the circumference formula for a circle?
#choices(
[$A = pi r^2$],
[$C = 2 pi r$],
[$C = pi r^2$],
[$A = 2 pi r$],
)
]

#question()[What is the main conflict in _The Odyssey_?
#choices(
[Odysseus seeks revenge on Achilles],
[Odysseus attempts to return home],
[Odysseus tries to conquer Egypt],
[Odysseus searches for Atlantis],
)
]

#pagebreak()

= SHORT ANSWER QUESTIONS

== Each of these has space-below: 1fr

#question(space-below: 1fr)[Solve for $x$: $3 x + 9 = 15$]

#question(space-below: 1fr)[Find the value of $4^3$.]

#question(space-below: 1fr)[Simplify: $5x + 2x - 9$.]

#question(space-below: 1fr)[Find the slope of the line passing through $(1, 2)$ and $(5, 10)$.]

#question(space-below: 1fr)[What is the area of a triangle with base $10$ and height $6$?]

#pagebreak()

#question(space-below: 1fr)[Name the author of _Macbeth_.]

#question(space-below: 1fr)[What year did the American Revolution begin?]

#question(space-below: 1fr)[Solve: $2(x - 4) = 10$.]

#question(space-below: 1fr)[Convert $45%$ to a decimal.]

#question(space-below: 1fr)[Name one cause of the fall of the Roman Republic.]

#pagebreak()

= ESSAY WITH PARTS

== This is still janky. Needs proper spacing logic.

#question()[Was Brutus's participation in the assassination of Julius Caesar just?
#parts(
[Would he be justified from a Roman point of view?],
[Would he be justified from a Christian point of view?],
)
]

#v(1fr)

#question()[Analyze the character of Achilles in the _Iliad_.
#parts(
[How does Achilles change throughout the epic?],
[What role does pride play in his decisions?],
[Would the Greeks have won without him?],
)
]

#v(1fr)


// ─────────────────────────────────────────────────────────────────────────────
//  END OF EXAM
// ─────────────────────────────────────────────────────────────────────────────

#v(24pt)
#align(center)[
  #line(length: 60%, stroke: 1pt + accent)
  #v(6pt)
  #text(size: 10pt, fill: luma(80), style: "italic")[
    — End of Exam — Check your work before turning in your paper. —
  ]
]
