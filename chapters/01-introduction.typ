#import "../preamble.typ": *

= Introduction <ch:intro>

Today's applications are ever-growing in size and complexity, and ever more user
data is being processed through these systems. To ensure that the users to whom
this data belongs are afforded privacy and that the computer systems are secure,
engineers and architects conduct mainly laborious manual audits. Some
code-analysis tools are also in use, but they lack the ergonomics and
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
they are ill-adapted to the dynamic nature of AI-enabled applications.

This thesis comprises two projects that address roadblocks in the application of
formal guardrails to realistic applications. Paralegal is a static analyzer for
Rust programs. It presents an ergonomic interface to privacy and security policy
authoring based on _markers_, text objects attached to source code elements. For
classical applications, static analysis offers the benefit of providing
guarantees at compile time, and does not impact runtime performance or alter
runtime behavior in surprising ways. The enforcement engine, a program
dependence graph (PDG) based analyzer, uses these markers as well as guarantees
provided by Rust's type-system enforced ownership model to make the analysis
scale to real-world Rust programs.

Palsgraf on the other hand addresses the novel threat, posed to users, from the
addition of agentic AI. Applications that use agentic AI are highly dynamic.
Their strength lies in performing tasks that are, at build time, unanticipated, and
at creating tools for solving these tasks on-the-fly. This makes static techniques
ill-suited for ensuring an AI-enabled application preserves user privacy and security
without eliminating the adaptability for which the AI was employed in the first place.

Dynamic techniques also struggle in the agentic AI setting. Traditionally, the
dynamism for these techniques is related to runtime inputs, whereas policies are
statically fixed. With agentic AI, the tasks performed are not known ahead of
time and only task-specific policies can distinguish desired behavior from
dangerous violations.

Palsgraf is a dynamic policy enforcement engine with first-class support
for task-specific policies. To ensure the policies are trustworthy Palsgraf uses
the user as the source of the policies. Creating formal task-specific policies takes
however a lot of effort. To alleviate this burden Palsgraf prompts the agent
itself to draft the policy. Palsgraf then renders this policy in human readable
form to the user for approval. This mechanism is predicated on a policy that is
concise and easy for users to understand. To facilitate this Palsgraf uses an
expert-authored registry of parameterized shapes of shell commands and network requests.
Each such shape is given a meaningful name that the user would recognize.
For example, `GIT_COMMIT(where="/projects/foo")` is a meaningful effect to
a typical developer and they need not reason about the fact that this means, internally,
that this rule will forbid the `--force` flag.

#import "../figures/common-thread.typ": common-thread-figure
#common-thread-figure <fig:common-thread>

In both cases existing systems fail to bridge the divide between what users can
specify and what a deterministic engine can enforce. PDGs reason about how
low-level values in the program relate to one another. Policy writers meanwhile
consider high-level actions, such as encryption, and high-level concepts, such
as user data. Developers, in turn, are experts about the code base and can
relate these concepts to concrete code objects, such as functions and types.
Paralegal provides an interface at just this boundary, allowing policy writers to
define meaningful concepts and developers to instantiate and maintain them
with respect to the codebase. As a result, policies need fewer revisions by experts
and developers gain a tool they can use frequently to establish confidence in the
compliance of their applications.

In a similar manner, sandboxes enforce access control at the level of system
calls. To a user who wants a file edited, a `write` system call is meaningful.
However, in many cases, system calls are too low level. For instance, the `git commit`
command causes a series of file reads and writes that are part of `git`'s
internal protocol that few users have in-depth familiarity with. System calls
also reason poorly about external communication, because the effect caused by
the communication is determined by its payload but the protocols, such as HTTPS,
largely use encryption, thus hiding the payloads at the system call level.
Palsgraf enables experts to define a vocabulary that encodes high-level actions
performed via shell commands and fine-grained external effects caused by
network requests. Experts need only revise these rarely, while users frequently
use and recombine them to assemble task-specific policies.



#todo[
  *2. The common thread, made explicit + a running example.* The intro now
  describes two projects back to back but never says what makes them one thesis.
  Add a section (or a closing paragraph) that:
  - Puts markers and actions side by side as the _same_ construct: a name that a
    non-expert already understands, attached to a program entity, that an
    enforcer can check mechanically. `user_data`/`deletes` and
    `GIT_COMMIT(where=…)` are the same idea at two different binding times.
  - Picks one or two concrete incidents to carry through the whole thesis. Best
    candidates: Plume's missing comment deletion (the Paralegal running example,
    already has code, policy and PDG figures) and the Railway volume-delete
    incident (`investigations/11-volume-delete-incident/`) for Palsgraf. Both
    are real, both are one-sentence explainable, and both fail for the same
    reason: the person who could have caught it was not shown the effect in
    terms they reason about.
  - States the shape of the answer once, then says each chapter instantiates it.
]

== Trust and Threat Model

The assumption for this work is that users can be trusted to specify policies, but
they may fail to produce code that upholds them. We do not trust agents to
produce correct policies or correct implementations, though we need their cooperation
to make progress.

For Paralegal, we trust a knowledgeable policy engineer to specify privacy and
security policies, define markers and document what those markers mean.
Developers, as experts in the application, are trusted to apply the markers to
code entities. Paralegal's goal is to help developers who make mistakes when
writing the actual application. As such, we do not trust the developer to get
the implementation right, especially in an evolving code base. The developers
are trusted to place the markers correctly, since that is a _rare_ and
_high-impact_ action and thus warrants careful treatment and review.

Palsgraf _guarantees_ that every effect a task's execution produces is
bound by the policy in effect at that time. The system does not ensure that the
executed effects achieve the task or that the LLM's outputs are correct.
Side-channels, kernel compromise and sandbox failure are out of scope.

_The TCB_ encompasses the sandbox, the
kernel that supports the sandbox as well as the network and shell brokers. The
system does not trust the user's (possibly copy-pasted) prompt, but it trusts
the user to review proposed policies and it trusts the on-disk actions
catalog's web request predicates, shell command footprint specifications and
policy files.

The _agent is untrusted_ and Palsgraf relies on it only for utility. The agent can
get confused about what goal it is supposed to achieve or attempt unsafe means
to achieve it. An _adversary_ may hijack the agent by altering web responses
from compromised web servers or by placing content in files the agent
legitimately needs to read, such as a public code repository. The adversary may
modify the user's machine only via the agent. Both adversary and agent have
full knowledge of the policy.

== Contributions

This work makes the following contributions:

+ The Paralegal static analyzer, which checks high-level
  properties against low-level, evolving code bases.
+ The marker abstraction to decouple policies and code; and techniques to
  efficiently generate precise semantic PDGs from Rust code and model the
  behavior of library code.
+ A flexible policy framework that compiles policies in a high-level
  language into queries on semantic PDGs.
+ Case studies reporting on our experience of applying Paralegal to eight
  real-world Rust web applications.
+ A policy language and action verb mechanism that lets users express
  policies at the level of meaningful effect units.
+ A scheme and mechanism for agents to draft policies and users to review them,
  compatible with MCP.
+ A sandbox adaptation that allows judging network requests on payload and
  protocol program arguments.

#todo[
  *4. Contributions and roadmap.* Standard, but missing, and it is where the
  two-projects-one-thesis claim gets made concrete. One numbered list of
  contributions (marker abstraction + PDG-based checking + the real bugs found;
  action registry + sandbox enforcement + agent-drafts/user-approves loop; and
  the cross-cutting claim about vocabularies), then a one-paragraph chapter map.
  Note which chapters derive from published work (the OSDI'25 Paralegal paper)
  and state the authorship split for the co-authored material, which the
  Graduate School expects.
]
