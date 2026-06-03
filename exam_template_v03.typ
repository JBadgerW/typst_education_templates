// ─────────────────────────────────────────────────────────────────────────────
//  Final Exam Template
//  ► Completely self-contained — no external imports required.
//  ► Fill in the capitalised placeholders (COURSE NAME, etc.) to customise.
// ─────────────────────────────────────────────────────────────────────────────

// CONTENT STARTS ON LINE 275ish

// ── Document metadata ────────────────────────────────────────────────────────
#let exam-title = "[exam name]"
#let exam-author = "[exam author]"

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
  let labeled = items.pos().enumerate().map(((i, item)) => {
    let label = numbering("A.", i + 1)
    let indent = 1.5em  // adjust to match label + gap width
    block(
      width: 100%,
      grid(
        columns: (indent, 1fr),
        column-gutter: 0pt,
        align(top, label),
        block(width: 100%, [#set par(hanging-indent: 0em); #item]),
      )
    )
  })

  if arrangement == "vertical" {
    stack(dir: ttb, spacing: 0.75em, ..labeled)
  } else if arrangement == "linear" {
    labeled.join(h(1.5em))
  } else if arrangement == "grid" {
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
          a,
          if b != none { b } else [],
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
