#import "../preamble.typ": *

= Background <ch:background>


== Data and Control Flow Analysis

Dataflow analysis is crucial when determining the privacy compliance of
programs. Whether a datum is private cannot always be determined by its content.
PII (name, SSN, telephone number) can sometimes be identified via its unique
structure. However, private data is a broader category, and data such as diary
or email content, bank balances or contracted illnesses are often embedded in
unstructured prose which also colocates data that may be sufficient to determine
the data subject.

A reliable way to determine if data is private is by considering the data
source, e.g. a bank statement, patient chart etc. This means however that in a
program that manipulates such data, it cannot be determined at the sink whether
the data that was input to the operation is private *unless* its origins have
been tracked through the program.

A primary challenge in statically determining the origins of a datum in a program
is pointers. Which value a given pointer may refer to, and therefore whether
one of them could be sensitive or not, depends on all parts of the program that
may modify the pointer. This is called alias analysis and unlike many other parts of
dataflow analysis it is a non-local analysis, meaning it cannot be performed
for one function alone, but must take into account all of its callers. This
leads to an explosion of the state space.

#todo[
  *5. Finish the aliasing story — Rust as the escape hatch.* This section stops
  at "the state space explodes" and never says how Paralegal gets out. Continue
  with:
  - Ownership and borrowing as a _locally checkable_ aliasing discipline: a
    `&mut` is unique, so a callee's writes are bounded by its signature. This is
    the thing that lets a modular analysis stay sound without a whole-program
    alias analysis.
  - MIR as the analysis target — post-monomorphization, post-desugaring, why
    that matters for precision and for handling generics/trait dispatch.
  - Where the discipline breaks: `unsafe`, interior mutability, FFI, raw
    pointers. Be honest about what Paralegal assumes here; it is the first thing
    a reader will poke at.
  - Short contrast with the Java/Android lineage (FlowDroid, DroidSafe) to make
    the point that the language choice is doing analytical work, not just
    engineering convenience.
]

#todo[
  *6. New section: Policy languages and information-flow control.* This is where
  you establish that "shared vocabulary" is the axis nobody else optimized for.
  Write about:
  - The IFC lineage: label lattices, Jif, HLIO; then the dynamic/application
    line — Resin, Jacqueline, Riverbed, Sesame; then the compliance-oriented
    line — PrivGuard, RuleKeeper.
  - The recurring shape: an expressive labeling discipline that requires the
    policy author to also be a programming-languages expert, or that is
    expressive only over noninterference-shaped properties.
  - The thesis's wedge: many real privacy properties are _not_ noninterference
    (deletion completeness, expiration, authorization, third-party sharing). A
    marker vocabulary plus reachability over a PDG expresses them; a lattice
    does not. This is the argument the Paralegal chapter's comparison table
    (against IFC and CodeQL) cashes out, so set it up here.
]

#todo[
  *7. New section: Confinement and sandboxing.* Background for the Palsgraf
  chapter, and the second half of the vocabulary argument. Cover:
  - The mechanism layer: OS namespaces and overlayfs, bubblewrap, Seatbelt/SBPL,
    seccomp; and the in-process line for contrast — NaCl, RLBox, WebAssembly,
    Ryoan.
  - The observation that reframes them: these mechanisms are configured in
    _kernel nouns_ — paths, mounts, syscalls, hosts — while the person granting
    permission thinks in _task nouns_. A user can meaningfully approve "commit
    to this repo" and cannot meaningfully approve a mount layout. That gap is
    exactly the gap markers close on the static side.
  - Why coarse sandboxes are the honest baseline and where they fail: a
    project-wide allow list either blocks benign work or admits the harmful
    case; your `coarse-sandbox` protection column is empirical evidence for
    this, so foreshadow it.
]

== Agentic AI

#figure(
  image("../assets/Overview.pdf"),
  caption: [
      An agentic AI application uses an interpreter to call tools requested by an LLM
  ]
)

The basic architecture of agentic loops is remarkably simple and, crucially, has
deterministic programs on the critical path. Conceptually, agentic AI lets a
language model "invoke tools", that is, programs. However, in reality, the AI
itself has no means of directly running these programs. Its inputs and outputs
are simply text~@codemodeanthropic@codemodecloudflare. A special interpreter
processes the text produced by the LLM and _this interpreter_ invokes programs
in response to LLM requests. A common architecture is that the LLM returns all
of its responses in JSON format, with a `type` field that identifies the request
as, for example, `thinking`, `user_response` or `tool_call`. Depending on this
choice the interpreter performs dispatch back to the LLM (`thinking`), to the UI
renderer (`user_response`) or a program (`tool_call`). This means the
interpreter retains full control over how the tool call proceeds. It can, for
example, log the request, inspect or change its arguments, fabricate the
response or outright deny it.

#todo[
  *8. Extend this section: the agentic threat landscape, and why model-level
  defenses are not enforcement.* You have established that a deterministic
  interpreter sits on the critical path — good, that is the opening. Now write
  the threat side:
  - The attack classes, with the citations already in `refs.yaml`: prompt
    injection (OWASP LLM01), sensitive-information disclosure (LLM02),
    adversarial SEO, universal/transferable jailbreaks. Then the supply-chain
    surface that is specific to agents: MCP servers, skills, ClawHub, and the
    OpenClaw CVEs and issues you have collected.
  - The accident class, which is distinct and probably more common: the Railway
    volume delete, the Replit production-database wipe, the SABER operational-
    safety results. Make the point that guardrails must catch both, and that the
    accident case is what makes user-facing legibility (not just isolation) the
    requirement.
  - Why alignment, system prompts and in-agent rules are advisory: cite the
    statistical-jailbreaking result and the volume-delete confession, where the
    agent quotes the rule it violated. This is the paragraph that justifies
    "deterministic" in the title.
  - Position the existing defenses so the reader knows what is new: CaMeL,
    Fides, ACE, Progent, IsolateGPT, Conseca, and the permission-prompt status
    quo (Claude Code, VS Code). Sort them by _who authors the policy_ and _in
    what vocabulary_ — that framing is your contribution and it makes the
    related-work chapter mostly write itself.
  #linebreak()
  _Figure:_ the existing `assets/Overview.pdf` covers the loop; consider a second
  one overlaying where each defense intercepts (model, interpreter, syscall).
]


// Numbering restarts per chapter: see @tab:results in @ch:intro versus the next
// figure.

// #figure(
//   rect(width: 50%, height: 1in, stroke: palette.gray),
//   caption: [Numbered 2.1.],
// )
