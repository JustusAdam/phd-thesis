// Figures for @ch:paralegal, preserved from the OSDI'25 Paralegal paper.
// Sources live in `assets/paralegal/`; see `assets/README-imported.md` for the
// provenance table and for what could not be copied.

#import "../lib/brown-thesis.typ": palette
#import "@preview/codly:1.3.0"
#import "@preview/subpar:0.2.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "util.typ": subfig-numbering, tight as _tight

#let _missing = palette.red-screen
#let _marked = rgb("#137C7C")

// ---------------------------------------------------------------------------
// The workflow. Verbatim from the paper (`figures/paralegal-overview.pdf`).
// ---------------------------------------------------------------------------
#let overview = figure(
  image("../assets/paralegal/paralegal-overview.pdf", width: 90%),
  caption: [
    Paralegal's workflow. A privacy engineer writes a policy over marker names;
    a developer attaches those markers to source entities. The analyzer builds a
    marked program dependence graph over the application and its libraries, and
    checks the policy against it. Neither author reasons about the graph, and
    the analyzer assigns no meaning to the names.
  ],
)

// ---------------------------------------------------------------------------
// The running example: Plume's user deletion, with the missing code.
// Reproduced from `assets/paralegal/plume-altered.rs`; the paper drew the
// missing lines in red and the markers in blue.
// ---------------------------------------------------------------------------
// Line numbers matter here: @fig:marked-pdg refers to lines of this listing.
// codly's `highlights` take (line, start, end); `start: 1, end: none` spans the
// whole line. The annotation replaces the caption's "the red lines are the bug"
// with a label the reader sees next to the code.
#let plume-listing = figure(
  _tight(codly.local(
    annotation-format: none,
    highlights: (
      (line: 1, start: 1, end: none, fill: _marked),
      (line: 5, start: 1, end: none, fill: _marked),
      (line: 10, start: 1, end: none, fill: _marked),
      // 17--19 are the comment-deletion code that was missing in the real bug.
      (line: 17, start: 1, end: none, fill: _missing),
      (line: 18, start: 1, end: none, fill: _missing),
      (line: 19, start: 1, end: none, fill: _missing),
    ),
    annotations: (
      (
        start: 17,
        end: 19,
        content: block(width: 3.4em, align(left, text(
          size: 0.7em,
          fill: _missing,
          [the bug],
        ))),
      ),
    ),
    ```rust
    #[paralegal::marker(user_data)]
    struct Comment { ... }

    impl Database {
      #[paralegal::marker(make_delete_query, arguments = [id])]
      fn prepare_delete(&mut self, id: u32, table: &str) {...}
    }

    impl User {
      #[paralegal::analyze]
      fn delete_user(&self, db: &mut Database) {
        let my_data: UserData = self.get_my_data();
        db.prepare_delete(self.id, "users");
        for post in &my_data.posts {
          db.prepare_delete(post.id, "posts");
        }
        for comment in &my_data.comments {
          db.prepare_delete(comment.id, "comments");
        }
        db.execute();
      }
    }
    ```,
  )),
  caption: [
    Paralegal alerts developers to the missing code (red) that deletes a user's
    comments when deleting their account in Plume. Markers are highlighted in
    teal. Code simplified and error handling omitted.
  ],
)

// ---------------------------------------------------------------------------
// The policy, before and after the give-and-take with the developer.
// ---------------------------------------------------------------------------
// subpar gives these real sub-references (@fig:deletion-policies-revised), so
// the prose can point at the revised policy rather than at the pair.
// Policies are not referenced by line, so the numbers would be noise.
#let _policy(body) = _tight(codly.local(number-format: none, body))

#let deletion-policy-initial = figure(
  _policy[```text
  Somewhere:
  1. For each "user data" type marked user_data:
    A. There is a "source" that produces "user data" where:
      a. There is a "deleter" marked deletes where:
        i) "source" goes to "deleter"
  ```],
  caption: [The initial policy.],
)

#let deletion-policy-revised = figure(
  _policy[```text
  Somewhere:
  1. For each "user data" type marked user_data:
    A. There is a "source" that produces "user data" where:
      a. There is a "deleter" marked make_delete_query where:
        i)  "source" goes to "deleter"
        and
        ii) There is an "execute" marked executes where:
          A) "deleter" goes to "execute"
  ```],
  caption: [The revised policy.],
)

// See the note in `palsgraf.typ`: the tightening belongs on the grid.
#let deletion-policies = _tight(subpar.grid(
  ..subfig-numbering,
  columns: 1,
  row-gutter: 8pt,
  deletion-policy-initial, <fig:deletion-policy-initial>,
  deletion-policy-revised, <fig:deletion-policy-revised>,
  label: <fig:deletion-policies>,
  caption: [
    User-data deletion written in Paralegal's policy language.
    @fig:deletion-policy-initial is too coarse: it is satisfied by code that
    only builds a deletion query. @fig:deletion-policy-revised additionally
    requires the query to reach an `executes` marker, which needs a new marker
    from the developer.
    This give-and-take between privacy engineer and developer is the common
    workflow, and it is why the vocabulary has to be cheap to extend.
  ],
))

// ---------------------------------------------------------------------------
// The marked PDG for the example above. Redrawn from the paper's
// `figures/plume-pdg.pdf` (a draw.io export, kept in `assets/` for comparison).
//
// Redrawn rather than ported for two reasons: the paper's version labels the
// function scope `delete_user @ L8`, but `delete_user` is on line 11 of
// @lst:plume-delete --- every other line reference (L13, L14, L15, L18, L20)
// checks out, so that one label was stale --- and a drawing this central to the
// chapter should restyle with the thesis rather than stay a frozen bitmap.
// ---------------------------------------------------------------------------
#let _pdg-red = palette.red.lighten(80%)
#let _pdg-marker = rgb("#7FDBDB").lighten(20%)

#let _pdg-node(pos, body, fill: white) = node(
  pos,
  text(font: "DejaVu Sans Mono", size: 0.75em, body),
  shape: rect,
  fill: fill,
  stroke: 0.5pt + black,
  inset: 4pt,
)

#let _pdg-marker-node(pos, body) = node(
  pos,
  text(font: "DejaVu Sans Mono", size: 0.7em, style: "italic", body),
  shape: rect,
  fill: _pdg-marker,
  stroke: 0.5pt + palette.gray,
  inset: 3pt,
  corner-radius: 3pt,
)

#let _pdg-scope(nodes, label-pos, label, fill: none, stroke-color: black) = (
  node(
    enclose: nodes,
    stroke: (dash: "dashed", paint: stroke-color, thickness: 0.5pt),
    fill: fill,
    inset: 7pt,
    snap: -1,
  ),
  node(label-pos, text(font: "DejaVu Sans Mono", size: 0.75em, label)),
)

#let plume-pdg = figure(
  kind: image,
  supplement: [Figure],
  block(width: 100%, {
    set par(justify: false)
    diagram(
      spacing: (6mm, 7mm),
      node-inset: 4pt,

      // --- the posts branch, which the code gets right --------------------
      _pdg-node((1.5, 0))[self.id @ start],

      _pdg-node((0, 1))[db @ L13],
      _pdg-marker-node((1.0, 1))[user_data],
      _pdg-node((2.0, 1))[my_data.posts @ L14],

      _pdg-node((0, 2))[self @ L15→start],
      _pdg-node((2.0, 2))[id @ L15→start],
      _pdg-marker-node((3.1, 1.6))[make_delete_query],

      _pdg-node((0, 3))[self @ L15→end],
      .._pdg-scope(
        ((0, 2), (2.0, 2), (0, 3)),
        (2.0, 3),
        [prepare_delete @ L15],
      ),

      // --- the comments branch, which is missing --------------------------
      _pdg-marker-node((1.0, 4))[user_data],
      _pdg-node((2.0, 4))[my_data.comments @ L14],

      _pdg-node((0, 5), fill: _pdg-red)[self @ L18→start],
      _pdg-node((2.0, 5), fill: _pdg-red)[id @ L18→start],
      _pdg-marker-node((3.1, 4.6))[make_delete_query],

      _pdg-node((0, 6), fill: _pdg-red)[self @ L18→end],
      .._pdg-scope(
        ((0, 5), (2.0, 5), (0, 6)),
        (2.0, 6),
        text(fill: palette.red-screen)[prepare_delete @ L18],
        fill: _pdg-red.lighten(45%),
        stroke-color: palette.red-screen,
      ),

      // --- the execution ---------------------------------------------------
      _pdg-node((0, 7))[db @ L20],
      _pdg-marker-node((1.0, 7))[executes],

      // --- edges ------------------------------------------------------------
      edge((0, 0.35), (0, 1), stroke: (dash: "dotted", thickness: 0.6pt), marks: "-|>"),
      edge((1.5, 0), (2.0, 1), marks: "-|>", stroke: 0.6pt),
      // Bowed right so it routes around the L15 scope instead of through it.
      edge((1.5, 0), (2.0, 4), marks: "-|>", stroke: 0.6pt, bend: 55deg),
      edge((0, 1), (0, 2), marks: "-|>", stroke: 0.6pt),
      edge((2.0, 1), (2.0, 2), marks: "-|>", stroke: 0.6pt),
      edge((0, 2), (0, 3), marks: "-|>", stroke: 0.6pt),
      edge((2.0, 2), (0, 3), marks: "-|>", stroke: 0.6pt),
      edge((2.0, 4), (2.0, 5), marks: "-|>", stroke: 0.6pt + palette.red-screen),
      edge((0, 3), (0, 5), marks: "-|>", stroke: 0.6pt + palette.red-screen),
      edge((0, 5), (0, 6), marks: "-|>", stroke: 0.6pt + palette.red-screen),
      edge((2.0, 5), (0, 6), marks: "-|>", stroke: 0.6pt + palette.red-screen),
      edge((0, 6), (0, 7), marks: "-|>", stroke: 0.6pt),

      // --- the enclosing function scope -------------------------------------
      // L11, not the L8 the paper's drawing says.
      .._pdg-scope(
        ((1.5, 0), (0, 1), (3.1, 1.6), (0, 7), (3.1, 4.6)),
        (2.4, 7),
        [delete_user @ L11],
      ),
    )
  }),
  caption: [
    Partial and simplified marked PDG for the deletion example. Solid
    rectangles are PDG nodes, dashed rectangles are function scopes, and the
    rounded boxes are markers. The red subgraph is the comment-deletion code
    that was missing. "L$k$" refers to line $k$ of @lst:plume-delete; "start"
    and "end" are the function entry and exit locations.
  ],
)

// ---------------------------------------------------------------------------
// Performance. All verbatim from the paper's plots.
// ---------------------------------------------------------------------------
#let runtime-interactive = figure(
  image("../assets/paralegal/ide_plot.pdf", width: 100%),
  caption: [
    In the "Workspace Only" configuration, which analyzes only the crates in the
    current workspace, Paralegal's end-to-end runtime is under 2.1 seconds for
    most applications --- fast enough to run interactively. The exceptions are
    Lemmy, which has 72 analysis entry points, and Hyperswitch, which is a large
    crate. PDG construction dominates.
  ],
)

#let runtime-ci = figure(
  image("../assets/paralegal/ci_plot.pdf", width: 100%),
  caption: [
    In the "All Dependencies" configuration, which analyzes the application
    together with its dependencies, runtimes remain compatible with a CI budget.
  ],
)

#let runtime-per-endpoint = figure(
  image("../assets/paralegal/per_controller_plot.pdf", width: 100%),
  caption: [
    Paralegal takes a mean of 0.8 seconds per endpoint, so cost scales with the
    number of analysis entry points rather than with total application size.
  ],
)

#let adaptive-approximation = figure(
  image("../assets/paralegal/k_depth_plot.pdf", width: 100%),
  caption: [
    Adaptive approximation reduces end-to-end runtime: without it, PDG
    construction inlines call sites that cannot affect the policy's verdict.
    This is what makes the interactive numbers above achievable.
  ],
)
