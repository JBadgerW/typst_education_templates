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


