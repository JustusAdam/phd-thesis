// The figure for @ch:intro: Paralegal and Palsgraf as two instantiations of the
// same structure. Read it row-wise --- the rows are the claim, the columns are
// the two systems.

#import "../lib/brown-thesis.typ": palette
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let _vocab-fill = palette.gold.lighten(70%)
#let _expert-fill = blue.lighten(70%)
#let _out-fill = palette.red.lighten(80%)

#let _party(pos, body, ..other) = node(
  pos,
  body,
  shape: rect,
  stroke: 0.5pt + palette.gray,
  inset: 5pt,
  width: 40mm,
  ..other,
)

#let _band(pos, body, fill: none, stroke-color: palette.gray) = node(
  pos,
  body,
  shape: rect,
  fill: fill,
  stroke: 0.5pt + stroke-color,
  inset: 5pt,
  width: 84mm,
)

#let _rowlabel(pos, body) = node(
  pos,
  align(right, text(size: 0.8em, style: "italic", fill: palette.brown, body)),
)

#let _colhead(pos, name, kind) = node(pos, align(center)[
  #text(weight: "bold", name) \
  #text(size: 0.8em, style: "italic", fill: palette.gray, kind)
])

// Column centres: Paralegal at x = 1.5, Palsgraf at x = 4.5. The two party
// boxes in each column sit at x ± 0.5 and feed into the vocabulary band, so the
// convergence is drawn rather than implied.
#let _arrow = (stroke: 0.6pt + palette.gray, marks: "-|>")

#let common-thread-figure = figure(
  kind: image,
  supplement: [Figure],
  // Justification inside the boxes leaves rivers; they are too narrow for it.
  block(width: 100%, {
    set par(justify: false)
    diagram(
      spacing: (2mm, 7mm),
      node-inset: 4pt,

      // header
      _colhead((1.5, 0), [Paralegal], [static, at build time]),
      _colhead((4.5, 0), [Palsgraf], [dynamic, at run time]),

      // who authors
      _rowlabel((-0.7, 1))[Authorship],
      _party((1, 1), fill: _expert-fill)[*Privacy engineer* \ writes the policy],
      _party((2, 1))[*Developer* \ attaches markers to code],
      _party((4, 1), fill: _expert-fill)[*Registry author* \ names the effect shapes],
      _party((5, 1))[*Agent* drafts, \ *user* approves, per task],

      edge((1, 1), (1.5, 2), .._arrow),
      edge((2, 1), (1.5, 2), .._arrow),
      edge((4, 1), (4.5, 2), .._arrow),
      edge((5, 1), (4.5, 2), .._arrow),

      // the vocabulary
      _rowlabel((-0.7, 2))[Shared\ Vocabulary],
      _band((1.5, 2), fill: _vocab-fill, stroke-color: palette.brown)[
        *markers* \
        `user_data`, `deletes`, `stores` \
        #text(size: 0.85em, style: "italic")[uninterpreted names on source entities]
      ],
      _band((4.5, 2), fill: _vocab-fill, stroke-color: palette.brown)[
        *actions* \
        `GIT_COMMIT(where="/proj")` \
        #text(size: 0.85em, style: "italic")[parameterized shapes of commands and requests]
      ],

      edge((1.5, 2), (1.5, 3), .._arrow),
      edge((4.5, 2), (4.5, 3), .._arrow),

      // the enforcer
      _rowlabel((-0.7, 3))[Enforcement],
      _band((1.5, 3))[marked PDG, checked by graph analysis],
      _band((4.5, 3))[sandbox: mount layout and egress proxy],

      edge((1.5, 3), (1.5, 4), .._arrow),
      edge((4.5, 3), (4.5, 4), .._arrow),

      // the outcome
      _rowlabel((-0.7, 4))[Outcome],
      _band((1.5, 4), fill: _out-fill, stroke-color: palette.red-screen)[
        a privacy bug reported before deployment
      ],
      _band((4.5, 4), fill: _out-fill, stroke-color: palette.red-screen)[
        an effect refused before it happens
      ],
    )
  }),
  caption: [
    Comparison of the high-level structure of both systems. The vocabulary
    (middle row, #box(fill: _vocab-fill)[highlighted]) forms the interface
    between rarely engaged #box(fill: _expert-fill)[experts] and usual users.
    Both systems compile policies over the vocabulary to a sound check.
  ],
)
