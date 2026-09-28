#import "../preamble.typ": *

= Introduction <ch:intro>

Today's applications are ever-growing in size and complexity, and ever more user
data is being processed through these systems. To ensure that the users to whom
this data belongs are afforded privacy and that the computer systems are secure,
engineers and architects conduct mainly laborious manual audits. Some
code-analysis tools are in use also, but they lack the ergonomics and
scalability to be applied broadly. With the advent of agentic AI, these problems
are exacerbated as developers increasingly do not write the code themselves.
Code reviews become even more laborious, as LLMs generate vast amounts of code
in minimal time. In many cases, the core of the applications themselves becomes
agentic AI, a fundamentally unpredictable component. 

Human reasoning alone will not efficiently scale to the complexity of modern
applications. At the same time, automated tools must deliver reliable results,
which disqualifies approaches that use AI on the critical path. This leaves 
formal techniques, such as static analysis, proofs, sandboxing or instrumentation.
Traditionally, these are used only in high-impact areas as they require additional
expertise to use effectively. They often struggle to scale to large code bases and
they are ill-adapted to the dynamic nature of AI enabled applications.

This thesis comprises two projects that address roadblocks in the application of
formal guardrails to realistic applications. Paralegal is a static analyzer for
Rust programs. In presents an ergonomic interface to privacy and security policy
authoring based on _markers_, text objects attached to source code elements. For
classical applications, static analysis offers the benefit of providing
guarantees at compile time, and do not impact runtime performance or alter
runtime behavior in surprising ways. The enforcement engine, a program
dependence graph (PDG) based analyzer, uses these markers as well as guarantees
provided by Rust's type-system enforced ownership model to make the analysis
scale to real-world scale Rust programs. 

Palsgraf on the other hand addresses the novel threat, posed to users, from the
addition of agentic AI. Applications that use agentic AI are highly dynamic.
There strength lies in performing tasks that are, at build time, unanticipated, and 
at creating tools for solving these tasks on-the-fly. This makes static techniques 
ill suited for ensuring an AI enabled application preserves user privacy and security
without eliminating the adaptability for which the AI was employed in the first place.

Dynamic techniques also struggle in the agentic AI setting. Traditionally, the
dynamism for these techniques is related to runtime inputs, whereas policies are
statically fixed. With agentic AI, the tasks performed are not known ahead of
time and only task-specific policies can distinguish desired behavior from
dangerous violations.

Palsgraf is a dynamic policy enforcement engine that with first-class support
for task-specific policies. To ensure the policies are trustworthy Palsgraf uses
the user as source of the policies. Creating format task-specific policies takes
however a lot of effort. to alleviate this burden Palsgraf prompts the agent
itself to draft the policy. Palsgraf then renders this policy in human readable
form to the user for approval. This mechanism is predicated on a policy that is
concise and easy for users to understand. To facilitate this Palsgraf uses an
expert-authored, registry of parameterized shapes of shell commands and network requests.
Each such shape is given a meaningful name that the user would recognize. 
For example, the `GIT_COMMIT(where="/projects/foo")` is a meaningful effect to
a typical developer and they need not reason about the fact that this means, internally,
that this rule will forbid the `--force` flag.



// This skeleton shows the moving parts. Body text is double-spaced; block
// quotes, captions, footnotes#footnote[Like this one, single-spaced.] and
// headings are single-spaced. Cite as usual @pierce2002types. #todo[Remove
// before the final build, which fails on any remaining `todo`.]

// == Contributions

// #definition(name: [Well-typed])[
//   A term $e$ is _well-typed_ if there is a type $tau$ with $emptyset tack.r e : tau$.
// ] <def:welltyped>

// #theorem(name: [Type safety])[
//   If $emptyset tack.r e : tau$, then $e$ does not get stuck.
// ] <thm:safety>

// #proof[By progress and preservation; see @app:proofs.]

// @thm:safety relies on @def:welltyped. Equations number per chapter:
// $ Gamma tack.r e_1 : tau_1 -> tau_2 quad Gamma tack.r e_2 : tau_1 ==> Gamma tack.r e_1 space e_2 : tau_2 $ <eq:app>

// #figure(
//   table(
//     columns: 3,
//     [*System*], [*Overhead*], [*Leaks*],
//     [Baseline], [1.00×], [yes],
//     [Ours], [1.07×], [no],
//   ),
//   caption: [Tables get captions on top.],
// ) <tab:results>

// #figure(
//   rect(width: 60%, height: 1.2in, stroke: palette.gray)[#align(center + horizon)[figure]],
//   caption: [Illustrations get captions below.],
// ) <fig:overview>

// ```rust
// fn main() {
//     println!("code blocks are single-spaced");
// }
// ```
