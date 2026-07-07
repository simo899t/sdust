// ══════════════════════════════════════════════════════
// IMPORTS
// ══════════════════════════════════════════════════════

#import "@preview/wordometer:0.1.5": word-count as _word-count, total-words as totalwords
#let word-count = _word-count
#let total-words = totalwords
#import "@preview/plotsy-3d:0.2.1": plot-3d-surface
#import "@preview/lovelace:0.3.0": *
#import "@preview/tdtr:0.5.2" : *
#import "@preview/h-graph:0.1.0": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/curryst:0.6.0": rule, prooftree, rule-set
#import "@preview/codly:1.3.0": codly, codly-init, no-codly
#import "@preview/codly-languages:0.1.10": codly-languages
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/itemize:0.2.0" as itmz
#let dirgraph(src) = h-graph(src, polar-render)

// simple node/edge graph, e.g.
// #graph(
//   nodes: ((pos: (0,0), label: $1$), (pos: (1,1), label: $2$)),
//   edges: (((0,0), (1,1)),),
// )
#let graph(nodes: (), edges: (), spacing: 3em, radius: 1.2em, arrow: "-", caption: none) = figure(
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: spacing,
    ..nodes.map(n => node(n.pos, n.label, radius: radius)),
    ..edges.map(e => edge(e.at(0), e.at(1), e.at(2, default: arrow))),
  ),
  caption: caption,
)


// ══════════════════════════════════════════════════════
// BASE STYLE
// ══════════════════════════════════════════════════════

// Fancy (default) code block styling — language-colored tab with icon,
// zebra striping, rounded block. This is what raw blocks look like unless
// a region is wrapped in #simple-code[...].
#let code-style(body) = {
  show: codly-init
  codly(
    languages: codly-languages,
    zebra-fill: luma(246),
    display-name: true,
    display-icon: true,
    radius: 5pt,
    inset: (left: 6pt, right: 6pt, top: 4pt, bottom: 4pt),
    stroke: 0.8pt + luma(220),
  )
  show raw.where(block: true): set text(font: ("Menlo", "DejaVu Sans Mono"), size: 9.5pt)
  show raw.where(block: false): it => box(
    fill: rgb("#eeeeee"),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
    text(fill: rgb("#1c1e26"), font: ("Menlo", "DejaVu Sans Mono"), size: 9pt, it),
  )
  body
}

// Opt a region out of codly back to a plain, unstyled code block.
// Usage: #simple-code[ ```py ... ``` ]
#let simple-code(body) = no-codly(body)

#let base-style(body) = {
  show: _word-count
  set text(font: "Computer Modern", size: 12pt)
  set heading(numbering: "1.1")
  set enum(numbering: "1.")
  show: itmz.default-enum-list.with(indent: auto, item-spacing: auto)
  set math.equation(numbering: none)
  set math.mat(delim: "[", gap: 0.3em)
  set par(justify: true)
  set image(width: 30em)
  show grid: it => {
    set image(width: auto)
    it
  }
  show: code-style
  body
}

#let bib = bibliography.with(style: "chicago-author-date")

#let pageSetup(body) = {
  set page(paper: "us-letter", margin: (left: 3cm, right: 3cm, top: 2cm, bottom: 2cm))
  base-style(body)
}

// ══════════════════════════════════════════════════════
// PROOF TREES  (curryst)
// ══════════════════════════════════════════════════════
#let prooftree = rule(
  label: [Label],
  name: [Rule name],
  [Premise 1],
  [Premise 2],
  [Premise 3],
  [Conclusion],
)
// Pseudocode
#let pseudo(body) = {
  show math.equation.where(block: true): eq => block(width: 100%, align(center, eq))
  pseudocode-list(body)
}

// ══════════════════════════════════════════════════════
// TREES  (tidy)
// ══════════════════════════════════════════════════════
#let tree(body, reverse: false, shape: "circle", draw-node: none, ..args) = {
  let shape-draw-node = if shape == "circle" {
    tidy-tree-draws.circle-draw-node
  } else if shape == "rect" or shape == "rectangle" {
    ((name, label, pos)) => (pos: (pos.x, pos.y), label: [#label], name: name, shape: rect)
  } else if shape == "square" {
    ((name, label, pos)) => (pos: (pos.x, pos.y), label: [#label], name: name, shape: rect, width: 1.6em, height: 1.6em)
  } else if shape == none {
    tidy-tree-draws.hidden-draw-node
  } else {
    tidy-tree-draws.circle-draw-node
  }
  let effective-draw-node = if draw-node != none { draw-node } else { shape-draw-node }
  let draw-nodes = if reverse {
    (effective-draw-node, ((name, label, pos)) => (pos: (pos.x, -pos.y)))
  } else {
    effective-draw-node
  }
  tidy-tree-graph(body, draw-node: draw-nodes, ..args)
}


// ══════════════════════════════════════════════════════
// UTILITIES
// ══════════════════════════════════════════════════════

#let _fmt-authors(author) = {
  if type(author) == str { author }
  else { author.join(" · ") }
}

#let group-by-pairs(elements) = {
  let lefts = elements
    .enumerate()
    .filter(((index, _)) => calc.rem(index, 2) == 0)
    .map(((_, element)) => element)
  let rights = elements
    .enumerate()
    .filter(((index, _)) => calc.rem(index, 2) == 1)
    .map(((_, element)) => element)
  lefts.zip(rights)
}

// Cases helper: alternating value/condition pairs.
// #mycases($x$, $x > 0$, $-x$, $x <= 0$)
// Optional word: prefix for conditions (e.g. word: "if")
#let mycases(..cases, word: none) = {
  let cases = group-by-pairs(cases.pos())
    .map(((value, condition)) => {
      if word != none {
        $#value quad &#word #condition$
      } else {
        $#value quad & #condition$
      }
    })
  math.cases(..cases)
}


// ══════════════════════════════════════════════════════
// CARD COMPONENTS
// ══════════════════════════════════════════════════════

// Internal base: coloured header bar + tinted body.
#let _titled-card(
  title: none,
  width: 100%,
  header-fill: rgb("#334155"),
  body-fill: rgb("#f8fafc"),
  border: rgb("#d8dde6"),
  body-text-fill: rgb("#1c1e26"),
  body-font: auto,
  body-size: 10.5pt,
  body-leading: 0.65em,
  content,
) = std.block(
  width: width,
  stroke: 0.5pt + border,
  radius: 2pt,
  clip: true,
  {
    if title != none {
      std.block(
        width: 100%,
        above: 0pt,
        below: 0pt,
        fill: header-fill,
        inset: (left: 14pt, right: 14pt, top: 8pt, bottom: 8pt),
        text(fill: white, weight: "bold", size: 10.5pt, title),
      )
    }
    std.block(
      width: 100%,
      above: 0pt,
      below: 0pt,
      fill: body-fill,
      inset: (left: 14pt, right: 14pt, top: 10pt, bottom: 10pt),
      {
        set par(leading: body-leading)
        set text(fill: body-text-fill, size: body-size, ..(if body-font == auto { (:) } else { (font: body-font) }))
        content
      },
    )
  },
)

// gray default block
#let block(title: none, width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#6b7280"), body-fill: rgb("#f3f4f6"),
  border: rgb("#d1d5db"), body-text-fill: rgb("#1f2937"),
  content,
)

// blue theorem
#let theorem(title: "Theorem", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#1565c0"), body-fill: rgb("#ecf3fc"),
  border: rgb("#b3cdeb"), body-text-fill: rgb("#0d2e57"),
  content,
)

// purple corollary
#let corollary(title: "Corollary", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#6d28d9"), body-fill: rgb("#f3ecfd"),
  border: rgb("#d8b9f2"), body-text-fill: rgb("#3b1257"),
  content,
)

// green definition
#let definition(title: "Definition", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#2e7d32"), body-fill: rgb("#ecfdf5"),
  border: rgb("#a7f3d0"), body-text-fill: rgb("#14532d"),
  content,
)

// red example
#let example(title: "Example", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#c62828"), body-fill: rgb("#fdeced"),
  border: rgb("#f2b9bc"), body-text-fill: rgb("#5a1212"),
  content,
)

// white/neutral proof — same shape as example, plain color, ends with QED
#let proof(title: "Proof", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#4b5563"), body-fill: white,
  border: rgb("#d1d5db"), body-text-fill: rgb("#1f2937"),
  [#content #QED],
)

// inline typst logo
#let typst = {
  set text(
    size: 1.05em,
    font: "Buenard",
    weight: "bold",
    fill: rgb("#239dad"),
  )
  box({
    text("t")
    text("y")
    h(0.035em)
    text("p")
    h(-0.025em)
    text("s")
    h(-0.015em)
    text("t")
  })
}


// ══════════════════════════════════════════════════════
// DOCUMENT TEMPLATES
//
// All cover pages accept an optional `logo:` parameter (image content,
// e.g. `image("logo.png", width: 15em)`). Left as `none` by default so
// this package carries no institutional branding — pass your own logo
// from the calling document, or wrap these templates with your
// institution's defaults in your own package.
// ══════════════════════════════════════════════════════

#let default-title  = "Untitled Document"
#let default-course = "University"
#let default-author = "Firstname Lastname"
#let default-date   = "16/12/2002"

// ── note ─────────────────────────────────────────────
#let note(
  title: default-title,
  subtitle: none,
  author: default-author,
  course: default-course,
  date: default-date,
  logo: none,
  outline: true,
  outline-depth: none,
  ..args,
) = {
  let body = args.pos().at(0, default: [])
  set page(paper: "us-letter", margin: (left: 3cm, right: 3cm, top: 3cm, bottom: 3cm))
  align(center,
    stack(
      spacing: 0pt,
      v(1.2cm),
      line(length: 100%, stroke: 3pt + rgb("#2c5aa0")),
      v(1.2em),
      text(size: 9.5pt, fill: rgb("#2c5aa0"), tracking: 2.5pt, weight: "bold")[LECTURE NOTES],
      v(2.5cm),
      text(size: 30pt, weight: "bold")[#title],
      if subtitle != none {
        stack(v(1em), text(size: 14pt, fill: rgb("#444444"), style: "italic")[#subtitle])
      },
      v(1.3em),
      line(length: 28%, stroke: 0.5pt + rgb("#bbbbbb")),
      v(0.7em),
      text(size: 14pt, fill: rgb("#444444"))[#course],
      v(1fr),
      text(size: 12pt)[#_fmt-authors(author)],
      v(0.3em),
      text(size: 11pt, fill: rgb("#888888"))[#date],
      if logo != none { stack(v(1.8em), logo) },
      v(1cm),
    )
  )
  pagebreak()
  if outline { std.outline(depth: outline-depth); pagebreak() }
  base-style(body)
}

// ── exercise ─────────────────────────────────────────
#let exercise(
  title: default-title,
  author: default-author,
  course: default-course,
  date: default-date,
  logo: none,
  outline: true,
  outline-depth: none,
  ..args,
) = {
  let body = args.pos().at(0, default: [])
  set page(paper: "us-letter", margin: (left: 3cm, right: 3cm, top: 3cm, bottom: 3cm))
  align(center,
    stack(
      spacing: 0pt,
      v(1.2cm),
      line(length: 100%, stroke: 3pt + rgb("#b7410e")),
      v(1.2em),
      text(size: 9.5pt, fill: rgb("#b7410e"), tracking: 2.5pt, weight: "bold")[EXERCISES],
      v(2.5cm),
      text(size: 30pt, weight: "bold")[#title],
      v(1.3em),
      line(length: 28%, stroke: 0.5pt + rgb("#bbbbbb")),
      v(0.7em),
      text(size: 14pt, fill: rgb("#444444"))[#course],
      v(1fr),
      text(size: 12pt)[#_fmt-authors(author)],
      v(0.3em),
      text(size: 11pt, fill: rgb("#888888"))[#date],
      if logo != none { stack(v(1.8em), logo) },
      v(1cm),
    )
  )
  pagebreak()
  if outline { std.outline(depth: outline-depth); pagebreak() }
  base-style(body)
}

// ── assignment ───────────────────────────────────────
#let assignment(
  title: default-title,
  author: default-author,
  course: default-course,
  date: default-date,
  logo: none,
  outline: true,
  outline-depth: none,
  ..args,
) = {
  let body = args.pos().at(0, default: [])
  set page(paper: "us-letter", margin: (left: 3cm, right: 3cm, top: 3cm, bottom: 3cm))
  align(center,
    stack(
      spacing: 0pt,
      v(1.2cm),
      line(length: 100%, stroke: 3pt + rgb("#b7410e")),
      v(1.2em),
      text(size: 9.5pt, fill: rgb("#621e00"), tracking: 2.5pt, weight: "bold")[ASSIGNMENTS],
      v(2.5cm),
      text(size: 30pt, weight: "bold")[#title],
      v(1.3em),
      line(length: 28%, stroke: 0.5pt + rgb("#bbbbbb")),
      v(0.7em),
      text(size: 14pt, fill: rgb("#444444"))[#course],
      v(1fr),
      text(size: 12pt)[#_fmt-authors(author)],
      v(1.8em),
      text(size: 11pt, fill: rgb("#888888"))[#date],
      if logo != none { stack(v(1.8em), logo) },
      v(1cm),
    )
  )
  pagebreak()
  if outline { std.outline(depth: outline-depth); pagebreak() }
  base-style(body)
}

// ── project ──────────────────────────────────────────
#let project(
  title: default-title,
  subtitle: none,
  author: default-author,
  course: default-course,
  date: default-date,
  group: none,
  supervisor: none,
  university: "University",
  logo: none,
  abstract: none,
  keywords: none,
  outline: true,
  outline-depth: none,
  ..args,
) = {
  let body = args.pos().at(0, default: [])
  set page(paper: "us-letter", margin: (left: 3cm, right: 3cm, top: 3cm, bottom: 3cm))
  align(center,
    stack(
      spacing: 0pt,
      v(1.5cm),
      text(size: 13pt, fill: rgb("#555555"))[#university],
      v(0.6em),
      line(length: 60%, stroke: 0.5pt + rgb("#aaaaaa")),
      v(3cm),
      text(size: 28pt, weight: "bold")[#title],
      if subtitle != none {
        stack(v(1.5em), text(size: 15pt, fill: rgb("#444444"), style: "italic")[#subtitle])
      },
      v(1em),
      line(length: 40%, stroke: 0.5pt + rgb("#aaaaaa")),
      v(1.3em),
      text(size: 14pt, fill: rgb("#333333"))[#course],
      v(1fr),
      {
        let author-arr = if type(author) == str {
          ((name: author),)
        } else if type(author) == array and author.len() > 0 and type(author.at(0)) == str {
          author.map(n => (name: n))
        } else if type(author) == array {
          author
        } else { ((name: str(author)),) }

        let render-author(a) = align(center, stack(
          spacing: 0.25em,
          text(weight: "bold", size: 11pt)[#a.at("name", default: "")],
          if a.at("email", default: "") != "" {
            text(size: 8.5pt, fill: rgb("#4a90d9"))[#a.at("email", default: "")]
          },
        ))

        let per-row = 3
        let row-starts = range(0, author-arr.len(), step: per-row)
        stack(spacing: 1.5em,
          ..row-starts.map(i => {
            let row = author-arr.slice(i, calc.min(i + per-row, author-arr.len()))
            align(center,
              box(width: (100% * row.len() / per-row),
                grid(columns: (1fr,) * row.len(), column-gutter: 2em,
                  ..row.map(render-author))
              )
            )
          })
        )
      },
      v(1.5em),
      std.block(
        width: 60%,
        stroke: (top: 0.5pt + rgb("#aaaaaa"), bottom: 0.5pt + rgb("#aaaaaa")),
        inset: (top: 1em, bottom: 1em),
        align(left, stack(
          spacing: 0.5em,
          if group != none {
            grid(columns: (4cm, 1fr),
              text(fill: rgb("#777777"))[*Group:*], text()[#group])
          },
          if supervisor != none {
            grid(columns: (4cm, 1fr),
              text(fill: rgb("#777777"))[*Supervisor:*], text()[#supervisor])
          },
          grid(columns: (4cm, 1fr),
            text(fill: rgb("#777777"))[*Date:*], text()[#date]),
        ))
      ),
      if abstract != none {
        stack(
          spacing: 0pt,
          v(1.5em),
          std.block(
            width: 80%, stroke: none, inset: (top: 0em, bottom: 0em),
            align(left, stack(
              spacing: 0.5em,
              text(weight: "bold", size: 10pt, fill: rgb("#333333"))[Abstract],
              line(length: 100%, stroke: 0.4pt + rgb("#cccccc")),
              v(0.3em),
              text(size: 9.5pt, fill: rgb("#444444"))[#abstract],
            ))
          ),
        )
      },
      if keywords != none {
        stack(
          spacing: 0pt,
          v(0.8em),
          std.block(
            width: 80%, inset: 0pt,
            align(left, text(size: 9.5pt)[
              #text(weight: "bold", fill: rgb("#333333"))[Keywords: ]
              #text(fill: rgb("#555555"))[
                #if type(keywords) == array { keywords.join(", ") } else { keywords }
              ]
            ])
          ),
        )
      },
      if logo != none { stack(v(1.8em), logo) },
      v(1cm),
    )
  )
  pagebreak()
  if outline { std.outline(depth: outline-depth); pagebreak() }
  base-style(body)
}

// ── exam ─────────────────────────────────────────────
#let exam(
  title: default-title,
  subtitle: none,
  author: default-author,
  course: default-course,
  date: default-date,
  student-id: none,
  username: none,
  student-number: none,
  duration: none,
  allowed-aids: none,
  university: "University",
  logo: none,
  outline: true,
  outline-depth: none,
  ..args,
) = {
  let body = args.pos().at(0, default: [])
  let author-name = if type(author) == str { author }
    else if type(author) == array and author.len() > 0 {
      if type(author.at(0)) == str { author.at(0) }
      else { author.at(0).at("name", default: "") }
    } else { "" }
  set page(
    paper: "us-letter",
    margin: (left: 3cm, right: 3cm, top: 3cm, bottom: 3cm),
    header: if username != none or student-number != none {
      set text(size: 9pt, fill: rgb("#555555"))
      grid(
        columns: (1fr, 1fr, 1fr),
        align(left)[#author-name],
        align(center)[#if username != none { username }],
        align(right)[#if student-number != none { student-number }],
      )
    },
  )
  align(center,
    stack(
      spacing: 0pt,
      v(1.5cm),
      text(size: 13pt, fill: rgb("#555555"))[#university],
      v(0.6em),
      line(length: 60%, stroke: 0.5pt + rgb("#aaaaaa")),
      v(0.5cm),
      text(size: 9.5pt, fill: rgb("#1a6b3c"), tracking: 2.5pt, weight: "bold")[EXAM],
      v(4.5cm),
      text(size: 28pt, weight: "bold")[#title],
      if subtitle != none {
        stack(v(1.5em), text(size: 15pt, fill: rgb("#444444"), style: "italic")[#subtitle])
      },
      v(1em),
      line(length: 40%, stroke: 0.5pt + rgb("#aaaaaa")),
      v(1.3em),
      text(size: 14pt, fill: rgb("#333333"))[#course],
      v(1fr),
      {
        let author-arr = if type(author) == str {
          ((name: author),)
        } else if type(author) == array and author.len() > 0 and type(author.at(0)) == str {
          author.map(n => (name: n))
        } else if type(author) == array {
          author
        } else { ((name: str(author)),) }

        let render-author(a) = align(center, stack(
          spacing: 0.25em,
          text(weight: "bold", size: 11pt)[#a.at("name", default: "")],
          if a.at("id", default: "") != "" {
            text(size: 9pt, fill: rgb("#555555"))[#a.at("id", default: "")]
          },
        ))

        let per-row = 3
        let row-starts = range(0, author-arr.len(), step: per-row)
        stack(spacing: 1.5em,
          ..row-starts.map(i => {
            let row = author-arr.slice(i, calc.min(i + per-row, author-arr.len()))
            align(center,
              box(width: (100% * row.len() / per-row),
                grid(columns: (1fr,) * row.len(), column-gutter: 2em,
                  ..row.map(render-author))
              )
            )
          })
        )
      },
      v(1.5em),
      std.block(
        width: 60%,
        stroke: (top: 0.5pt + rgb("#aaaaaa"), bottom: 0.5pt + rgb("#aaaaaa")),
        inset: (top: 1em, bottom: 1em),
        align(left, stack(
          spacing: 0.5em,
          if duration != none {
            grid(columns: (4cm, 1fr),
              text(fill: rgb("#777777"))[*Duration:*], text()[#duration])
          },
          if allowed-aids != none {
            grid(columns: (4cm, 1fr),
              text(fill: rgb("#777777"))[*Allowed aids:*], text()[#allowed-aids])
          },
          grid(columns: (4cm, 1fr),
            text(fill: rgb("#777777"))[*Date:*], text()[#date]),
        ))
      ),
      if logo != none { stack(v(1.8em), logo) },
      v(1cm),
    )
  )
  pagebreak()
  if outline { std.outline(depth: outline-depth); pagebreak() }
  base-style(body)
}

// ── chi — ACM CHI paper ──────────────────────────────
#let chi(
  title: default-title,
  authors: (),
  abstract: [],
  keywords: (),
  ccs: none,
  date: default-date,
  outline: false,
  ..args,
) = {
  let body = args.pos().at(0, default: [])
  set page(paper: "us-letter", margin: (x: 1.9cm, y: 2.3cm))
  set text(size: 9.5pt)

  v(0.5cm)
  align(center, text(size: 18pt, weight: "bold")[#title])
  v(1.5em)

  let authors-arr = if type(authors) == str {
    ((name: authors),)
  } else if authors.len() > 0 and type(authors.at(0)) == str {
    authors.map(n => (name: n))
  } else {
    authors
  }
  if authors-arr.len() > 0 {
    let render-author(a) = align(center, stack(
      spacing: 0.3em,
      text(weight: "bold", size: 10.5pt)[#a.at("name", default: "")],
      if a.at("institution", default: "") != "" { text(size: 9pt)[#a.at("institution", default: "")] },
      if a.at("city", default: "") != "" or "country" in a {
        text(size: 9pt)[#a.at("city", default: "")#if "country" in a [, #a.country]]
      },
      if a.at("email", default: "") != "" {
        text(size: 9pt, fill: rgb("#0055aa"))[#a.at("email", default: "")]
      },
    ))

    let n = authors-arr.len()
    let row-starts = range(0, n, step: 3)
    for i in row-starts {
      let row = authors-arr.slice(i, calc.min(i + 3, n))
      align(center,
        box(width: (100% * row.len() / 3),
          grid(columns: (1fr,) * row.len(), column-gutter: 2em,
            ..row.map(render-author))
        )
      )
      if i + 3 < n { v(1.5em) }
    }

    v(1.8em)
    align(center, text(size: 9pt, fill: rgb("#888888"))[#date])
    v(1em)
  }

  let has-meta = abstract != [] or keywords != () or ccs != none
  if has-meta {
    line(length: 100%, stroke: 0.5pt + rgb("#888888"))
    v(1em)
    columns(2, gutter: 1.5em, [
      #if abstract != [] {
        text(weight: "bold", size: 8.5pt, tracking: 0.8pt)[ABSTRACT]
        v(0.4em)
        abstract
      }
      #if ccs != none {
        v(0.8em)
        text(weight: "bold", size: 8.5pt, tracking: 0.8pt)[CCS CONCEPTS]
        v(0.4em)
        ccs
      }
      #if keywords != () {
        v(0.8em)
        text(weight: "bold", size: 8.5pt, tracking: 0.8pt)[KEYWORDS]
        v(0.4em)
        keywords.join("; ")
      }
    ])
  }

  line(length: 100%, stroke: 0.5pt + rgb("#888888"))
  v(1em)
  if outline { pagebreak(); std.outline(); pagebreak() }
  base-style(body)
}

/*
=============================================================
TEMPLATES — copy the block you need into a new file
=============================================================

── NOTE ──────────────────────────────────────────────────────
#import "@preview/sdust:0.1.0": *
#show: note.with(
  title:         "Lecture Notes",
  course:        "DM000 — Course Name",
  author:        "Firstname Lastname",
  date:          "date",
  logo:          image("logo.png", width: 15em),   // optional
  outline:       true,          // set false to skip TOC
  outline-depth: 2,             // none = unlimited depth
)

= First Section
Content goes here.

── EXERCISE ──────────────────────────────────────────────────
#import "@preview/sdust:0.1.0": *
#show: exercise.with(
  title:         "Exercises 1",
  course:        "DM000 — Course Name",
  author:        "Firstname Lastname",
  date:          "date",
  outline:       true,
  outline-depth: 2,
)

= Exercise 1
Content goes here.

── ASSIGNMENT ────────────────────────────────────────────────
#import "@preview/sdust:0.1.0": *
#show: assignment.with(
  title:         "Assignment 1",
  course:        "DM000 — Course Name",
  author:        "Firstname Lastname",
  date:          "date",
  outline:       true,
  outline-depth: 2,
)

= Problem 1
Content goes here.

── EXAM ──────────────────────────────────────────────────────
#import "@preview/sdust:0.1.0": *
#show: exam.with(
  title:         "Written Exam",
  subtitle:      "Re-exam",                    // optional
  course:        "DM000 — Course Name",
  author:        "Firstname Lastname",
  date:          "date",
  student-id:    "id",                         // optional
  username:      "username",                   // optional — shown in page header
  student-number: "215751682",                 // optional — shown in page header
  duration:      "4 hours",                    // optional
  allowed-aids:  "All written materials",      // optional
  university:    "University",
  outline:       false,
)

= Problem 1
Content goes here.

── PROJECT ───────────────────────────────────────────────────
#import "@preview/sdust:0.1.0": *
#show: project.with(
  title:         "Project Title",
  subtitle:      "Optional subtitle",          // optional
  course:        "DM000 — Course Name",
  author:        "Firstname Lastname",         // or array of dicts below
  date:          "date",
  group:         "Group 4",                    // optional
  supervisor:    "Prof. Firstname Lastname",   // optional
  university:    "University",
  outline:       true,
  outline-depth: 2,
)

= Introduction
Content goes here.

── CHI PAPER ─────────────────────────────────────────────────
#import "@preview/sdust:0.1.0": *
#show: chi.with(
  title: "Paper Title",
  authors: (
    (name: "Firstname Lastname", institution: "University", city: "City", country: "County", email: "mail@mail.com"),
  ),
  abstract: [Your abstract text here.],
  keywords: ("keyword one", "keyword two"),
  date:     "date",
)
#set page(columns: 2)

= Introduction
Content goes here.

*/
