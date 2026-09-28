#import "@preview/lilaq:0.6.0"
#import "@preview/subpar:0.2.2"
#import "@preview/fletcher:0.5.8"
#import "@preview/codly:1.3.0"

#import "lib/brown-thesis.typ": appendix, brown-thesis, palette
#import "meta.typ": meta

#show: brown-thesis.with(
  ..meta,
  //cv: include "front/cv.typ",
  acknowledgments: include "front/acknowledgments.typ",
  thesis-statement: include "front/thesis.typ",
  // license: [Licensed under CC BY 4.0.],
  logo: image("assets/Full Color VT.png", width: 1.6in),
  font: "Libertinus Serif",
  monochrome: false,
)

// Code listings. Set once here so every listing in the thesis looks the same;
// individual figures override with `codly.local(...)` where they need
// highlights or margin annotations.
#show: codly.codly-init
#codly.codly(
  zebra-fill: none,
  fill: none,
  stroke: none,
  inset: (x: 0.32em, y: 0em),
  display-name: false,
  display-icon: false,
  number-format: n => text(fill: palette.gray, size: 0.8em, str(n)),
  number-align: right + horizon,
)

#include "chapters/01-introduction.typ"
#include "chapters/02-background.typ"
#include "chapters/03-paralegal.typ"
#include "chapters/04-palsgraf.typ"
#include "chapters/05-conclusion.typ"

#bibliography("refs.yaml", title: [Bibliography], style: "association-for-computing-machinery")

// #show: appendix
// #include "appendices/a-proofs.typ"
