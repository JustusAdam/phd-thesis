#import "lib/brown-thesis.typ": appendix, brown-thesis
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

#include "chapters/01-introduction.typ"
#include "chapters/02-background.typ"

#bibliography("refs.yaml", title: [Bibliography], style: "association-for-computing-machinery")

// #show: appendix
// #include "appendices/a-proofs.typ"
