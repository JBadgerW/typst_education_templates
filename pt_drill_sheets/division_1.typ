#import sys: inputs
#import "layout_template.typ": header, title-bar

// Compile this file directly (no --input data=...) to use dummy_data.json
// for layout experiments. The real pipeline in drill_common.py always
// passes "data", so it's unaffected.
#let data = if "data" in sys.inputs {
  json(bytes(sys.inputs.at("data")))
} else {
  json("dummy_data.json")
}
#let seed = data.seed
#let title = data.title
#let ws-details = data.ws-details
#let worksheet-problems = data.problems.map(p => (p.a, p.b))

#set page(
  paper: "us-letter",
  margin: (
    top: 0.35in,
    left: 0.5in,
    right: 0.5in,
    bottom: 1.5in, //  Why does 1.5in == 0.5?
  ),
)

#set text(
  font: "Nimbus Sans",
  size: 12pt,
)

#let answer-blank(width) = box(
  width: width,
  inset: 0pt,
  stroke: (bottom: 0.7pt),
)

// The division-sign hook: a simple hand-drawn crescent (flat caps top and
// bottom, two cubics bulging out to the right). Drawn as its own closed
// shape, independent of the bar, which is a separate rectangle overlapping
// the hook's top cap -- much simpler than trying to make one continuous
// path do both jobs, and any overlap between the two is invisible since
// both are solid black. Proportions as fractions of the hook's own height:
#let cap-w = 0.10   // width of the flat cap at top and bottom
#let outer-x = 0.33   // outer curve's bulge, at mid-height
#let inner-x = 0.20   // inner curve's bulge, at mid-height

// The hook is drawn taller than the dividend's own text height, so it dips
// below the baseline instead of just matching the digits top-to-bottom.
#let hook-height-factor = 1.3

#let division(dividend, divisor, quotient, answer: false) = context {
  let dividend-body = [#dividend]
  let dsize = measure(dividend-body)
  let dw = dsize.width
  let dh = dsize.height

  let bar-gap = 0.05em // clearance between bar and tops of the dividend digits
  let overshoot = 0.12em // how far the bar runs past the dividend's right edge
  let pad = 0.05em // margin so nothing gets clipped

  let scale = dh + bar-gap // reference height: dividend height + gap
  let hook-h = scale * hook-height-factor // hook's own (taller) height
  let bar-thick = scale * cap-w // bar thickness matches the hook's own cap width
  let bar-end = scale * outer-x + dw + overshoot

  let sign-w = bar-end + pad
  let sign-h = scale + bar-thick + pad

  let sign = box(width: sign-w, height: sign-h)[
    #place(top + left, curve(
      fill: black,
      curve.move((scale * cap-w, 0em)),
      curve.cubic(
        (scale * outer-x, hook-h * 0.35),
        (scale * outer-x, hook-h * 0.65),
        (scale * cap-w, hook-h),
      ),
      curve.line((0em, hook-h)),
      curve.cubic(
        (scale * inner-x, hook-h * 0.65),
        (scale * inner-x, hook-h * 0.35),
        (0em, 0em),
      ),
      curve.close(mode: "straight"),
    ))
    #place(top + left, dx: 0.05em, rect(
      fill: black,
      stroke: none,
      width: bar-end,
      height: bar-thick,
    ))
    #place(bottom + left, dx: 0.3em)[#dividend]
  ]

  grid(
    columns: (auto, auto),
    // rows: (auto, 1.2em),
    // stroke: 1pt + red,
    inset: 0em,
    grid.cell(align: right)[],
    grid.cell(align: right, inset: (
      bottom: 0.15em,
      right: overshoot,
    ))[#if answer [#text(fill: red, weight: "bold")[#quotient]] else []],
    grid.cell(align: right + bottom, inset: (right: 0.05em))[#divisor],
    grid.cell(align: left + bottom)[#sign],
  )
}


// BEGINNING OF DOCUMENT CONTENT

#let problem-grid = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    rows: (1fr, 1fr),
    column-gutter: 0pt,
    inset: (bottom: 25pt),
    align: center + bottom, 

    ..for (a, b) in worksheet-problems {
      (
        table.cell[
          #division((a * b), b, a, answer: false)
        ],
      )
    }
  )
}

#let answer-grid = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    rows: 1fr,
    column-gutter: 0pt,
    inset: (bottom: 25pt),
    align: center + bottom, 

    ..for (a, b) in worksheet-problems {
      (
        table.cell[
          #division((a * b), b, a, answer: true)
        ],
      )
    }
  )
}

// LAYOUT

// Problems

#stack(
  dir: ttb,
  spacing: 0.3cm,
  header,
  stack(
    dir: ttb,
    spacing: 0cm,
    title-bar,
    problem-grid,
  ),
)

#pagebreak()

// Answers

#stack(
  dir: ttb,
  spacing: 1.3cm,
  [= Answers],
  stack(
    dir: ttb,
    spacing: 0cm,
    title-bar,
    answer-grid,
  ),
)


