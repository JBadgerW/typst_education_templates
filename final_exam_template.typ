// ─────────────────────────────────────────────────────────────────────────────
//  Final Exam Template
//  ► Completely self-contained — no external imports required.
//  ► Fill in the capitalised placeholders (COURSE NAME, etc.) to customise.
// ─────────────────────────────────────────────────────────────────────────────

// ── Document metadata ────────────────────────────────────────────────────────

#set document(
  title:  "COURSE NAME — Final Exam",
  author: "TEACHER NAME",
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
  margin: (top: 1in, bottom: 1in, left: 1in, right: 1in),

  // Running header — suppressed on page 1 (title block takes that role)
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 9pt, fill: luma(120))
      #grid(
        columns: (1fr, 1fr),
        align(left)[COURSE NAME — Final Exam],
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
#set par(justify: true, leading: 0.65em)
#set heading(numbering: none)

// ── Helper components ─────────────────────────────────────────────────────────

// Large coloured banner — use for major exam sections (Part I, Part II, …)
#let section-banner(title, points: none) = {
  v(20pt)
  block(
    width:  100%,
    fill:   accent,
    radius: 6pt,
    inset:  (x: 14pt, y: 10pt),
    below:  14pt,
  )[
    #set text(size: 16pt, weight: "bold", fill: white)
    #if points != none [
      #grid(
        columns: (1fr, auto),
        title,
        text(size: 12pt, weight: "regular")[#points pts],
      )
    ] else [
      #title
    ]
  ]
}

// Smaller coloured header — use for sub-sections or question groups
#let subsection-header(title, points: none) = {
  block(
    width:  100%,
    fill:   sec-col,
    radius: 4pt,
    inset:  (x: 12pt, y: 7pt),
    below:  10pt,
  )[
    #set text(size: 12pt, weight: "bold", fill: white)
    #if points != none [
      #grid(
        columns: (1fr, auto),
        title,
        text(size: 10pt, weight: "regular")[#points pts],
      )
    ] else [
      #title
    ]
  ]
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
    #text(size: 10pt, fill: luma(60), weight: "bold")[#upper(label) ]
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

// Numbered multiple-choice question
//   #mc-question(num: 1, stem: "...", choices: ("A", "B", "C", "D"))
#let mc-question(num: 1, stem: "", choices: ()) = {
  v(8pt)
  grid(
    columns: (auto, 1fr),
    gutter:  6pt,
    text(weight: "bold")[#num.],
    [
      #stem
      #v(4pt)
      #grid(
        columns: (auto, auto, auto, auto),
        gutter:  (12pt, 4pt),
        ..choices.enumerate().map(((i, c)) => {
          let letter = ("A", "B", "C", "D", "E").at(i)
          [*#letter.* #c]
        })
      )
    ],
  )
}

// True / False question wrapper (prints "(T / F)" prompt automatically)
#let tf-question(num: 1, stem: "") = {
  v(8pt)
  grid(
    columns: (auto, 1fr, auto),
    gutter:  6pt,
    text(weight: "bold")[#num.],
    stem,
    text(fill: luma(100))[(T / F)],
  )
}

// Point value label (right-aligned, used inline beside questions)
#let pts(n) = h(1fr) + text(size: 9pt, fill: luma(100))[_(#n pt#if n != 1 [s])_]

// ─────────────────────────────────────────────────────────────────────────────
//  EXAM TITLE BLOCK
//  Replace the capitalised placeholders with your own text.
// ─────────────────────────────────────────────────────────────────────────────

#align(center)[
  #v(8pt)
  #text(size: 26pt, weight: "bold", fill: accent)[COURSE NAME]
  #v(4pt)
  #text(size: 18pt, fill: luma(60))[Final Exam]
  #v(6pt)
  #line(length: 60%, stroke: 2pt + accent)
  #v(10pt)
]

// Student information row
#grid(
  columns: (2fr, 1fr, 1fr),
  gutter:  10pt,
  [
    Name: #box(width: 1fr)[#line(length: 100%, stroke: 0.5pt + luma(160))]
  ],
  [
    Period: #box(width: 1fr)[#line(length: 100%, stroke: 0.5pt + luma(160))]
  ],
  [
    Date: #box(width: 1fr)[#line(length: 100%, stroke: 0.5pt + luma(160))]
  ],
)

#v(6pt)

// Score / total row (optional — delete if your school uses its own cover sheet)
#grid(
  columns: (1fr, auto),
  [],
  block(
    stroke: 0.5pt + luma(200),
    radius: 4pt,
    inset:  (x: 14pt, y: 8pt),
  )[
    #text(size: 10pt)[Score: #h(24pt) / #h(8pt) #text(fill: luma(100))[\_\_\_\_\_\_ pts]]
  ],
)

#v(4pt)

// General instructions
#instruction-box[
  #text(weight: "bold")[Instructions] \
  Read each question carefully before answering.
  Show all work for full credit on calculation problems.
  Write neatly — illegible answers will not receive credit.
  You may use a calculator unless otherwise noted.
]

// ─────────────────────────────────────────────────────────────────────────────
//  PART I — MULTIPLE CHOICE  (example section)
// ─────────────────────────────────────────────────────────────────────────────

#section-banner("Part I — Multiple Choice", points: 20)

#instruction-box[
  Circle the letter of the best answer. Each question is worth 2 points.
]

#mc-question(
  num:     1,
  stem:    "Which of the following best describes velocity?",
  choices: (
    "Speed with no direction",
    "The total distance an object travels",
    "Speed in a specified direction",
    "The rate of change of acceleration",
  ),
)

#mc-question(
  num:     2,
  stem:    "An object in uniform circular motion has a constant ___.",
  choices: (
    "velocity",
    "speed",
    "acceleration",
    "net force",
  ),
)

// ── Add more questions by copying the #mc-question block above ────────────────

// ─────────────────────────────────────────────────────────────────────────────
//  PART II — TRUE / FALSE  (example section)
// ─────────────────────────────────────────────────────────────────────────────

#section-banner("Part II — True / False", points: 10)

#instruction-box[
  Circle *T* if the statement is true or *F* if it is false. Each is worth 1 point.
]

#tf-question(num: 1, stem: "Displacement is always equal to the total distance traveled.")
#tf-question(num: 2, stem: "Newton's Third Law states that every action has an equal and opposite reaction.")

// ─────────────────────────────────────────────────────────────────────────────
//  PART III — SHORT ANSWER  (example section)
// ─────────────────────────────────────────────────────────────────────────────

#section-banner("Part III — Short Answer", points: 30)

#instruction-box[
  Answer each question in complete sentences unless directed otherwise.
  Point values are shown beside each question.
]

// ── Question group with a subsection header ───────────────────────────────────

#subsection-header("Force and Motion", points: 15)

#v(8pt)
*1.* State Newton's Second Law in words and write its equation. #pts(3)
#answer-lines(3)

*2.* A 5 kg box is pushed with a net force of 20 N. What is its acceleration? Show your work. #pts(4)
#answer-lines(4)

// ─────────────────────────────────────────────────────────────────────────────
//  PART IV — EXTENDED RESPONSE  (example section)
// ─────────────────────────────────────────────────────────────────────────────

#section-banner("Part IV — Extended Response", points: 20)

#instruction-box[
  Answer the following question in a well-organised paragraph or more.
  Your response will be graded on accuracy, completeness, and clarity.
]

*1.* Describe the difference between constructive and destructive wave interference. Include a real-world example of each, and draw a simple sketch illustrating both types below. #pts(20)

#answer-lines(8)

#v(10pt)
#text(weight: "bold")[Sketch:]
#v(80pt)   // blank space for student drawing
#line(length: 100%, stroke: 0.5pt + luma(200))

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
