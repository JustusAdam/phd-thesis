// brown-thesis.typ: Brown University Ph.D. dissertation template.
//
// Structure adapted from harvard-gsas-thesis-oat (MIT, github.com/Moelf).
// Layout rules follow the Graduate School's dissertation guidelines and
// sample pages:
//   https://graduateschool.brown.edu/academics/rules-regulations/dissertation-guidelines
// Colours follow Brown's Visual Identity Policy.

// ---------------------------------------------------------------------------
// Brand palette
// ---------------------------------------------------------------------------
#let palette = (
  red: rgb("#ED1C24"), // Brown Red, PMS 2347 (print / logo)
  red-screen: rgb("#C00404"), // Brown Red as used by Brown units for on-screen text
  brown: rgb("#4E3629"), // Brown, PMS 476
  gold: rgb("#FFC72C"), // accent
  gray: rgb("#98A4AE"), // accent
)

// `typst compile --input draft=true ...` enables the draft watermark and
// renders todo()s; a final build fails on any remaining todo().
#let draft = sys.inputs.at("draft", default: "false") == "true"

#let todo(body) = if draft {
  box(
    fill: palette.gold.lighten(55%),
    inset: (x: 3pt),
    outset: (y: 2pt),
    radius: 2pt,
  )[*TODO:* #body]
} else {
  "unresolved todo() in a final build"
}

// ---------------------------------------------------------------------------
// Spacing. The text box is exactly 1em (top-edge 0.8em, bottom-edge -0.2em),
// so the line pitch is 1em + leading.
// ---------------------------------------------------------------------------
#let double-leading = 1em   // pitch 2em: true double spacing
#let single-leading = 0.2em // pitch 1.2em: single spacing
#let single-gap = 1.4em     // "single-spaced with a blank line between items"

#let single-spaced(body) = {
  set par(leading: single-leading, spacing: single-gap)
  body
}

// Figure kinds whose counters restart with each chapter.
#let figure-kinds = (image, table, raw, "theorem")

#let heading-depth(it) = it.at("depth", default: it.at("level", default: 1))

#let chapter-numbered(pattern) = (..n) => numbering(
  pattern,
  counter(heading).get().first(),
  ..n,
)

// ---------------------------------------------------------------------------
// Theorem-like environments: figures of kind "theorem" sharing one counter,
// so `@thm:x` renders as "Theorem 2.3". Styled in `brown-thesis` below.
// ---------------------------------------------------------------------------
#let theorem-like(supplement) = (name: none, body) => figure(
  kind: "theorem",
  supplement: supplement,
  caption: name,
  outlined: false,
  body,
)
#let theorem = theorem-like[Theorem]
#let lemma = theorem-like[Lemma]
#let corollary = theorem-like[Corollary]
#let definition = theorem-like[Definition]
#let proof(body) = block(width: 100%)[_Proof._ #body #h(1fr) $square$]

// ---------------------------------------------------------------------------
// Preliminary pages
// ---------------------------------------------------------------------------
#let date-line(conferral) = conferral.month + " " + str(conferral.year)

#let title-page(
  title: none,
  author: none,
  prior-degrees: (),
  department: none,
  degree: none,
  conferral: none,
  logo: none,
  title-color: black,
) = {
  set align(center)
  set par(first-line-indent: 0pt, justify: false, leading: single-leading)
  if logo != none {
    logo
    v(0.5in)
  } else {
    v(0.75in)
  }
  text(1.4em, weight: "bold", fill: title-color, title)
  v(1fr)
  [by \ #author]
  if prior-degrees.len() > 0 {
    v(1.2em)
    prior-degrees.join(linebreak())
  }
  v(1fr)
  block(width: 80%)[
    A dissertation submitted in partial fulfillment of the \
    requirements for the Degree of #degree \
    in the Department of #department at Brown University
  ]
  v(1fr)
  [Providence, Rhode Island \ #date-line(conferral)]
  v(0.5in)
}

#let copyright-page(author: none, conferral: none, license: none) = {
  place(center + horizon, align(center)[
    © Copyright #conferral.year by #author
    #if license != none [
      #v(1em)
      #set text(0.9em)
      #license
    ]
  ])
}

#let signature-line(name, role) = {
  set par(first-line-indent: 0pt)
  v(2.2em)
  grid(
    columns: (auto, 1fr),
    column-gutter: 1.5em,
    row-gutter: 0.5em,
    [Date #box(width: 1.2in, height: 0.8em, stroke: (bottom: 0.5pt))],
    box(width: 100%, height: 0.8em, stroke: (bottom: 0.5pt)),

    [], [#name, #role],
  )
}

#let signature-page(
  author: none,
  department: none,
  degree: none,
  advisor: none,
  readers: (),
  dean: none,
  ..rest,
) = {
  set par(first-line-indent: 0pt, justify: false, leading: single-leading)
  [
    This dissertation by #author is accepted in its present form \
    by the Department of #department as satisfying the \
    dissertation requirement for the degree of #degree.
  ]
  signature-line(advisor, [Advisor])
  v(2em)
  [Recommended to the Graduate Council]
  for r in readers { signature-line(r, [Reader]) }
  v(2em)
  [Approved by the Graduate Council]
  signature-line(dean, [Dean of the Graduate School])
}

// A front-matter section: styled like a chapter opening, not in the Contents.
#let prelim-section(title, body) = {
  heading(level: 1, numbering: none, outlined: false, title)
  body
}

// ---------------------------------------------------------------------------
// Main template
// ---------------------------------------------------------------------------
#let brown-thesis(
  title: [Dissertation Title],
  author: "Your Name",
  prior-degrees: (),
  department: "Computer Science",
  degree: "Doctor of Philosophy",
  conferral: (month: "May", year: 2027),
  advisor: "Advisor Name",
  readers: (),
  dean: "Dean Name",
  cv: none,
  acknowledgments: none,
  license: none,
  list-of-tables: true,
  list-of-figures: true,
  thesis-statement: none,
  logo: none,
  monochrome: false,
  font: "New Computer Modern",
  font-size: 12pt,
  body,
) = {
  let accent = if monochrome { black } else { palette.red-screen }
  let title-color = if monochrome { black } else { palette.brown }

  set document(title: title, author: author)
  set page(
    paper: "us-letter",
    // from the Graduate School's sample pages
    margin: (top: 1in, bottom: 1in, left: 1.5in, right: 1in),
    // page number centred, 3/4 in from the bottom edge
    footer-descent: 0.12in,
    header: none,
    numbering: "i",
    background: if draft {
      rotate(-45deg, text(90pt, fill: luma(238), weight: "bold")[DRAFT])
    },
  )
  set text(
    font: font,
    size: font-size,
    lang: "en",
    top-edge: 0.8em,
    bottom-edge: -0.2em,
  )
  set par(
    leading: double-leading,
    spacing: double-leading,
    justify: true,
    first-line-indent: (amount: 0.5in, all: false),
  )

  // Single-spaced material: block quotes, captions, long headings,
  // footnotes; also tables, code, the bibliography and the lists.
  show quote.where(block: true): single-spaced
  show figure: single-spaced
  show table: single-spaced
  show raw.where(block: true): set par(leading: 0.35em)
  show raw: set text(font: ("DejaVu Sans Mono",), size: 0.85em)
  show footnote.entry: set par(leading: single-leading)
  set footnote.entry(gap: 1.2em)
  show heading: set par(leading: single-leading, justify: false)
  show bibliography: single-spaced
  show outline: single-spaced
  show outline.entry.where(level: 1): set block(above: 1.4em)

  // Colour: URLs, cross-references and citations only.
  show link: it => if type(it.dest) == str { text(fill: accent, it) } else { it }
  show ref: set text(fill: accent)

  // Headings. Major divisions: new page, centred, upper case, two inches
  // from the top edge (1 in margin + 1 in).
  set heading(numbering: "1.1")
  set heading(supplement: it => if heading-depth(it) == 1 [Chapter] else [Section])
  show heading.where(level: 1): it => {
    for k in figure-kinds { counter(figure.where(kind: k)).update(0) }
    counter(math.equation).update(0)
    pagebreak(weak: true)
    v(1in)
    block(width: 100%, below: 3em, align(center, {
      set par(first-line-indent: 0pt)
      if it.numbering != none {
        text(fill: accent, tracking: 0.08em, upper(
          [#it.supplement #counter(heading).display(it.numbering)],
        ))
        v(0.6em)
      }
      text(1.15em, weight: "bold", fill: title-color, upper(it.body))
    }))
  }
  show heading.where(level: 2): set text(1.1em, fill: title-color)
  show heading.where(level: 3): set text(fill: title-color)
  show heading.where(level: 2): set block(above: 2.2em, below: 1.2em)
  show heading.where(level: 3): set block(above: 1.8em, below: 1em)

  // Chapter-scoped numbering for figures and equations.
  set figure(numbering: chapter-numbered("1.1"))
  set math.equation(numbering: chapter-numbered("(1.1)"))
  show figure.caption: it => align(left)[
    #strong[#it.supplement #context it.counter.display(it.numbering).]
    #it.body
  ]
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: "theorem"): it => block(width: 100%, breakable: true, align(left)[
    #set par(first-line-indent: 0pt)
    #strong[#it.supplement #context it.counter.display(it.numbering)]#if it.caption != none [ (#it.caption.body)]*.*
    #it.body
  ])
  show figure.where(kind: "theorem"): set block(breakable: true)

  // --- i: title page, ii: copyright page (counted, number not shown) ---
  set page(footer: none)
  counter(page).update(1)
  title-page(
    title: title,
    author: author,
    prior-degrees: prior-degrees,
    department: department,
    degree: degree,
    conferral: conferral,
    logo: logo,
    title-color: title-color,
  )
  pagebreak()
  copyright-page(author: author, conferral: conferral, license: license)
  pagebreak()

  // --- iii onward: numbered preliminary pages ---
  set page(footer: auto)
  signature-page(
    author: author,
    department: department,
    degree: degree,
    advisor: advisor,
    readers: readers,
    dean: dean,
  )
  if cv != none { prelim-section[Curriculum Vitae][#cv] }
  if acknowledgments != none { prelim-section[Preface and Acknowledgments][#acknowledgments] }
  if thesis-statement != none { prelim-section[Thesis Statement][#thesis-statement] }
  outline(title: [Contents], depth: 2)
  if list-of-tables { outline(title: [List of Tables], target: figure.where(kind: table)) }
  if list-of-figures { outline(title: [List of Illustrations], target: figure.where(kind: image)) }

  // --- dissertation proper: Arabic numerals from 1 ---
  set page(numbering: "1")
  counter(page).update(1)
  body
}

// Appendices: chapters lettered A, B, ...; apply with `#show: appendix`.
#let appendix(body) = {
  counter(heading).update(0)
  set heading(numbering: "A.1")
  set heading(supplement: it => if heading-depth(it) == 1 [Appendix] else [Section])
  set figure(numbering: chapter-numbered("A.1"))
  set math.equation(numbering: chapter-numbered("(A.1)"))
  body
}

// ---------------------------------------------------------------------------
// Standalone abstract (not part of the dissertation; submitted separately).
// Enforces the 350-word / 2,450-character limit in final builds.
// ---------------------------------------------------------------------------
#let to-plain(it) = {
  if it == none { "" } else if type(it) == str { it } else if it.func() in (parbreak, linebreak) or it == [ ] {
    " "
  } else if it.has("text") { it.text } else if it.has("children") { it.children.map(to-plain).join("") } else if it.has(
    "body",
  ) { to-plain(it.body) } else { "" }
}

#let abstract-page(
  title: none,
  author: none,
  conferral: none,
  degree-abbrev: "Ph.D.",
  font: "New Computer Modern",
  font-size: 12pt,
  ..rest,
  body,
) = {
  set document(title: [Abstract of #title], author: author)
  set page(paper: "us-letter", margin: (top: 1in, bottom: 1in, left: 1.5in, right: 1in))
  set text(font: font, size: font-size, lang: "en", top-edge: 0.8em, bottom-edge: -0.2em)
  set par(leading: double-leading, spacing: double-leading, justify: true)

  let plain = to-plain(body)
  let words = plain.split(regex("\s+")).filter(w => w != "").len()
  let chars = plain.trim().replace(regex("\s+"), " ").clusters().len()
  if not draft {
    assert(words <= 350, message: "abstract has " + str(words) + " words (max 350)")
    assert(chars <= 2450, message: "abstract has " + str(chars) + " characters (max 2450)")
  }

  [Abstract of #title, by #author, #degree-abbrev, Brown University, #date-line(conferral).]
  v(1em)
  body
  if draft {
    place(bottom + right, text(0.8em, fill: palette.red-screen)[#words words, #chars characters])
  }
}

// Standalone signature page, for printing and signing.
#let signature-document(..args) = {
  set page(paper: "us-letter", margin: (top: 1in, bottom: 1in, left: 1.5in, right: 1in))
  set text(font: "New Computer Modern", size: 12pt, lang: "en")
  signature-page(..args)
}
