// ─────────────────────────────────────────────────────────────────────────────
//  Cover Page — balanced layout revision
// ─────────────────────────────────────────────────────────────────────────────

// ── Cover-page variables ──────────────────────────────────────────────────────

#let school-name   = "Westbrook Academy"
#let exam-name     = "Final Examination"
#let class-name    = "Physical Science"
#let teacher-name  = "Mr. Jonathan Hart"
#let exam-date     = "5 June 2025"
#let school-motto  = "Scientia et Virtus"

#let logo-size     = 100pt

// ── Colour / font setup ───────────────────────────────────────────────────────

#let accent    = rgb("#092532")
#let sec-col   = rgb("#2e7d52")
#let box-bg    = rgb("#eef4fb")
#let rule-col  = luma(180)

#set page(paper: "us-letter",
          margin: (top: 0in, bottom: 0.75in, left: 0.75in, right: 0.75in))
#set text(font: "Linux Libertine O", size: 11pt)

// ─────────────────────────────────────────────────────────────────────────────

// ── Top accent band ───────────────────────────────────────────────────────────

#block(
  width:  100% + 1.5in,
  fill:   accent,
  inset:  (x: 0.75in, y: 18pt),
  below:  0pt,
)[
  #set text(font: "Helvetica Neue", fill: white)
  #align(center)[
    #text(size: 20pt, weight: "bold", tracking: 1.5pt)[
      #upper(school-name)
    ]
    #if school-motto != "" [
      #linebreak()
      #text(size: 9.5pt, weight: "regular", style: "italic")[
        #school-motto
      ]
    ]
  ]
]

// ── Logo + title: grouped together in the visual centre ───────────────────────
// Using 2fr above the group and 1fr below pulls the group into the upper-centre
// of the remaining page, which reads as balanced because the heavier name-field
// block below acts as a visual anchor.

#v(2fr)

#align(center)[
  #image("Torch_Only-SQUARE_White_BG.png", width: logo-size)
]

// Tight gap between logo and title — they belong to the same visual unit.
#v(28pt)

#align(center)[
  #line(length: 45%, stroke: 1.2pt + accent)
  #v(14pt)

  #text(
    font:   "Helvetica Neue",
    size:   26pt,
    weight: "bold",
    fill:   accent,
  )[#exam-name]

  #v(10pt)
  #text(
    font:  "Linux Libertine O",
    size:  15pt,
    fill:  luma(40),
    style: "italic",
  )[#class-name]

  #v(14pt)
  #line(length: 45%, stroke: 1.2pt + accent)
]

// Moderate gap before the metadata — related to the title but subordinate to it.
#v(24pt)

// ── Teacher / date metadata ───────────────────────────────────────────────────

#align(center)[
  #grid(
    columns:       (auto, auto),
    column-gutter: 48pt,
    row-gutter:    6pt,
    align:         (right, left),

    text(size: 9pt, fill: luma(100), font: "Helvetica Neue", weight: "bold")[
      #upper[Instructor]
    ],
    text(size: 11pt, fill: luma(30))[#teacher-name],

    text(size: 9pt, fill: luma(100), font: "Helvetica Neue", weight: "bold")[
      #upper[Date]
    ],
    text(size: 11pt, fill: luma(30))[#exam-date],
  )
]

// ── Student name field ────────────────────────────────────────────────────────
// 1fr here gives the name field a stable lower-third position while the logo+
// title group floats in the upper two-thirds. The field is centred to match
// every other element on the page.

#v(1fr)

#align(center)[
  #block(
    width:  82%,
    fill:   box-bg,
    stroke: (left: 4pt + accent),
    radius: (right: 4pt),
    inset:  (x: 16pt, y: 14pt),
  )[
    #set text(size: 9pt, fill: luma(80), font: "Helvetica Neue", weight: "bold")
    #align(left)[
      #upper[Student Name]
      #v(18pt)
      #line(length: 100%, stroke: 0.5pt + luma(160))
    ]
  ]
]

// ── Bottom decorative rule ────────────────────────────────────────────────────
// Fixed gap from the name field to the rule keeps the footer tight and
// predictable regardless of how much 1fr absorbs above.

#v(32pt)

#align(center)[
  #line(length: 67%, stroke: 0.8pt + rule-col)
  #v(6pt)
  #set text(size: 9pt, fill: luma(100), style: "italic")
  Do not open this exam until instructed to do so.
]

// ── Page break into exam body ─────────────────────────────────────────────────

#pagebreak()

#set page(margin: (top: 1in, bottom: 1in, left: 0.75in, right: 0.75in))
