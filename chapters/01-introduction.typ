#import "../preamble.typ": *

= Introduction <ch:intro>

This skeleton shows the moving parts. Body text is double-spaced; block
quotes, captions, footnotes#footnote[Like this one, single-spaced.] and
headings are single-spaced. Cite as usual @pierce2002types. #todo[Remove
before the final build, which fails on any remaining `todo`.]

== Contributions

#definition(name: [Well-typed])[
  A term $e$ is _well-typed_ if there is a type $tau$ with $emptyset tack.r e : tau$.
] <def:welltyped>

#theorem(name: [Type safety])[
  If $emptyset tack.r e : tau$, then $e$ does not get stuck.
] <thm:safety>

#proof[By progress and preservation; see @app:proofs.]

@thm:safety relies on @def:welltyped. Equations number per chapter:
$ Gamma tack.r e_1 : tau_1 -> tau_2 quad Gamma tack.r e_2 : tau_1 ==> Gamma tack.r e_1 space e_2 : tau_2 $ <eq:app>

#figure(
  table(
    columns: 3,
    [*System*], [*Overhead*], [*Leaks*],
    [Baseline], [1.00×], [yes],
    [Ours], [1.07×], [no],
  ),
  caption: [Tables get captions on top.],
) <tab:results>

#figure(
  rect(width: 60%, height: 1.2in, stroke: palette.gray)[#align(center + horizon)[figure]],
  caption: [Illustrations get captions below.],
) <fig:overview>

```rust
fn main() {
    println!("code blocks are single-spaced");
}
```
