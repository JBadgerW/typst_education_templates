// ─────────────────────────────────────────────────────────────────────────────
//  Cover Page — drop this block at the very top of exam_template_v03.typ,
//  immediately after the helper-component definitions and before "PART I".
//
//  Customise the six variables just below, then delete or replace the
//  placeholder logo with your school's actual image:
//      #image("logo.png", width: logo-size)
// ─────────────────────────────────────────────────────────────────────────────

// ── Cover-page variables ──────────────────────────────────────────────────────

#let school-name   = "Westbrook Academy"
#let exam-name     = "Final Examination"
#let class-name    = "Physical Science"
#let teacher-name  = "Mr. Jonathan Hart"
#let exam-date     = "5 June 2025"
#let school-motto  = "Scientia et virtus"   // set to "" to suppress

#let logo-size     = 100pt   // adjust to taste

// ─────────────────────────────────────────────────────────────────────────────
//  Paste everything below into your template file.
//  The colour variables (accent, sec-col, box-bg, rule-col) are assumed to
//  already be defined above this block, exactly as in exam_template_v03.typ.
// ─────────────────────────────────────────────────────────────────────────────

// ── Standalone demo: colour / font setup (remove when merging into template) ──
// #let accent    = rgb("#1a5c8a")
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
  width:  100% + 1.5in,   // bleed past the side margins
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

// ── Logo ──────────────────────────────────────────────────────────────────────
// Replace the SVG block below with:  #image("logo.png", width: logo-size)

#v(1fr)
#align(center)[
  #image("Torch_Only-SQUARE_White_BG.png", width: logo-size)
]

// ── Exam title block ──────────────────────────────────────────────────────────

#v(1fr)
#align(center)[
  // Thin rule above
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
  // Thin rule below
  #line(length: 45%, stroke: 1.2pt + accent)
]

// ── Teacher / date metadata ───────────────────────────────────────────────────

#v(1fr)
#align(center)[
  #grid(
    columns:      (auto, auto),
    column-gutter: 48pt,
    row-gutter:    6pt,
    align:         (right, left),

    // Labels
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

#v(1fr)
// #align(center)[
  #block(
    // width:  95%,
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
// ]

// ── Instructions notice ───────────────────────────────────────────────────────

// #v(12pt)
// #block(
//   width: 82%,
//   inset: (x: 16pt, y: 0pt),
// )[
//   #set text(size: 9pt, fill: luma(100), style: "italic")
//   #align(center)[
//     // Write your full name on every page. \ 
//     // Do not open this exam until instructed to do so.
//   ]
// ]

// ── Bottom decorative rule ────────────────────────────────────────────────────

#v(36pt)   // push rule to the bottom of the page
#align(center)[
  #line(length: 67%, stroke: 0.8pt + rule-col)
  // #v(5pt)
  #set text(size: 9pt, fill: luma(100), style: "italic")
    Do not open this exam until instructed to do so.
  // #text(size: 8pt, fill: luma(150), font: "Helvetica Neue")[
  //   #upper(school-name) · #exam-date
  // ]
]

// ── Page break into exam body ────────────────────────────────────────────────

#pagebreak()

// ── Restore normal page margins for the rest of the exam ─────────────────────
// (The top band above used margin: top: 0in; we reset here.)
#set page(margin: (top: 1in, bottom: 1in, left: 0.75in, right: 0.75in))
