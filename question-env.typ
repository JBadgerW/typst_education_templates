// Question Environment definitions
// Usage: #question(points: which is optional)[body of question]
//        #parts[] An inner environment for parts of a question
//        #choices(arragnement: stacked, linear, grid)[] for 
//          multiple choice questions

// Question counter
#let qnum = counter("question")

// Question environment
#let question(points: none, body) = {
  qnum.step()

  block(
    below: 1.5em,
  )[
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.5em,

      [
        #context{
          qnum.display("1.")  
        }
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
  }
}

