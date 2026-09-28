// Shared helpers for the figure files.

#import "../lib/brown-thesis.typ": chapter-numbered, palette

// codly lays a listing out as a `grid`, one row per line, so the line pitch
// comes from `grid.row-gutter` --- *not* from `par.leading`, which is the
// obvious guess and has no effect here. Left alone the gutter inherits the
// document's double spacing, and inside a `subpar.grid` even the template's
// `show figure: single-spaced` does not reach it. Setting the grid directly
// works in both places.
#let tight(body) = {
  set grid(row-gutter: 0.2em)
  set par(leading: 0.35em, spacing: 0.35em)
  body
}

// subpar does its own numbering, so it has to be told about the template's
// chapter-scoped scheme or sub-figures come out as "Figure 2a" in chapter 3.
//
// `numbering-sub` is deliberately left at subpar's default: its
// `sparse-numbering` helper only drops the super-number for *string* patterns,
// so handing it `chapter-numbered` here yields "(c(b(a)". The sub-caption does
// not want the chapter number anyway --- only the super figure and the
// cross-reference do.
#let subfig-numbering = (
  numbering: chapter-numbered("1.1"),
  numbering-sub-ref: chapter-numbered("1.1a"),
)
