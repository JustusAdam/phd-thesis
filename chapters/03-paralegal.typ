#import "../preamble.typ": *
#import "../figures/paralegal.typ" as pl

= Paralegal <ch:paralegal>

#pl.overview <fig:paralegal-overview>

#pl.plume-listing <lst:plume-delete>

// The label lives inside the subpar.grid, so it is not repeated here.
#pl.deletion-policies

#pl.plume-pdg <fig:marked-pdg>

#todo[
  *9. Markers as the vocabulary, and the division of labor.* Lead the chapter
  with the social structure, not the algorithm — it is the part that
  generalizes to @ch:palsgraf and the part the OSDI paper itself calls the key
  to practicality. Write about:
  - The three roles and what each one must know: privacy engineers write
    policies over marker names and know the regulation; developers apply markers
    to source entities and know the code; the analyzer knows neither and needs
    no semantics for the names at all. Markers are deliberately _uninterpreted_
    — say that explicitly, it is what makes the split possible.
  - What a marker can attach to (types, fields, arguments, returns, call sites)
    and why that granularity is the right unit.
  - Marker economics: how many are needed per application, who writes which,
    what happens as code evolves. The ergonomics evaluation already answers
    this; the argument to make here is that the annotation burden is bounded and
    amortized, because that is the objection to every annotation-based system.
  - The give-and-take loop from the Plume example: the first policy is wrong,
    the error message shows why, the policy and markers get revised together.
    This is the honest workflow and it is more convincing than a clean story.
  #linebreak()
  _Figures placed:_ @fig:paralegal-overview (the workflow, verbatim from the
  paper), @lst:plume-delete (the code, with the missing deletion highlighted and
  annotated), and @fig:deletion-policies — the before/after policy pair, which
  carries the give-and-take point better than prose. Point the text at
  @fig:deletion-policy-initial and @fig:deletion-policy-revised individually.
  _Still to port_ (a LaTeX table, so it needs retyping): `fig:apps` from
  `chapters/prototype.tex` — the applications table with LoC, policies, marked
  locations and entry points.
]

#todo[
  *10. The mechanism: marked PDGs and the policy language.* The technical core.
  Cover, roughly in this order:
  - PDG construction over MIR: what the nodes and edges are, data versus control
    dependence, how library code is modeled through ownership rather than
    analyzed, and where the analysis is modular versus whole-program.
  - Adaptive approximation and inconsequential call-site removal — the two
    optimizations that make it scale. Do not bury these; they are the reason the
    numbers are interactive rather than overnight, and one of them (Contile)
    determines whether an application is analyzable at all.
  - The policy language: the controlled-natural-language surface, its quantifier
    structure, what it compiles to, and the grammar. Argue the CNL choice on
    audience grounds (privacy engineers, not PL people), which is the same
    argument as the marker one.
  - Error messages as a first-class design concern — the Plume deletion error is
    a good concrete artifact to show.
  #linebreak()
  _Figures:_ @fig:marked-pdg is redrawn in Typst and placed above — it is the
  one picture that makes "marked PDG" concrete, so the walkthrough of PDG
  construction should be written against it. Note its function scope is labelled
  `L11`; the paper's drawing said `L8`, which was stale. _Still to port:_ the
  PDG/CFG grammar figure (`fig:grammar`, `chapters/pdg.tex`), which maps cleanly
  onto a Typst table.
]

#todo[
  *11. Evaluation, limits, and the bridge to @ch:palsgraf.* Write about:
  - The bugs: seven across Plume, Atomic and Lemmy, two previously unknown.
    Lead with these; they are the result.
  - Expressiveness against IFC and CodeQL — this is the section that cashes out
    @ch:background's claim that real privacy properties are not noninterference.
  - Performance, framed as a deployment claim rather than a benchmark: under
    interactive latency in the workspace configuration, tolerable in CI over all
    dependencies.
  - Ergonomics and maintenance under code evolution.
  - _Then the limits, stated by you rather than left to a reader:_ markers are
    trusted, not verified; the analysis is static so it says nothing about
    values or runtime configuration; `unsafe` and FFI are assumptions;
    applications must be Rust. Each of these is a reason Palsgraf is a different
    system rather than an extension — end the chapter by making that argument,
    since it is the hinge of the whole thesis.
  #linebreak()
  _Figures:_ the four performance plots below are placed already. _Still to
  port_ (LaTeX tables, so they need retyping): the bug table from
  `chapters/case-studies.tex`, the applications table `fig:apps` from
  `chapters/prototype.tex`, the IFC/CodeQL comparison `tab:results` from
  `chapters/eval-related-work.tex`, and the grammar `fig:grammar` from
  `chapters/pdg.tex`.
]

#pl.runtime-interactive <fig:runtime-interactive>

#pl.runtime-ci <fig:runtime-ci>

#pl.runtime-per-endpoint <fig:runtime-per-endpoint>

#pl.adaptive-approximation <fig:adaptive-approximation>
