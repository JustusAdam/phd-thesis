#import "../preamble.typ": *
#import "../figures/palsgraf.typ" as ps

= Palsgraf <ch:palsgraf>

// Labels live inside the subpar.grid, so they are not repeated here.
#ps.write-file-example

#ps.component-overview <fig:component-overview>



#todo[
  *12. The sandbox argument: why a sandbox, and why not a language.* Make this
  the first technical section, because it is the design decision a reader will
  challenge and because the investigations already contain the argument.
  Write about:
  - Why enforcement must be OS-level rather than in-language: an agent that can
    spawn a subprocess escapes any interpreter-level handler stack. The
    concrete finding is the right evidence — a gate on `net.request` meant
    nothing while `proc.spawn("curl")` was free. Generalize it: any effect
    mechanism the agent can reach around is not an enforcement mechanism.
  - Why a purpose-built effect language was considered and set aside. Be
    straight about the trade: a closed effect alphabet buys cheap, precise
    static synopses, and costs adoption — the agent must be persuaded to use it,
    and the corpus says agents reach for shell. State the sandbox as the
    conservative choice that assumes nothing about what the agent writes.
    (The language work still earns a paragraph as a design point explored and
    the source of the effect alphabet, rather than being silently dropped.)
  - What the sandbox is: mount layout derived from the path lists on Linux, an
    SBPL profile on macOS, egress forced through a policy-enforcing proxy.
    Most-specific-wins precedence rather than deny-beats-allow, and why.
  - The two design consequences worth defending in print: writes are direct
    rather than staged (so the enforcement decision happens at the syscall, not
    at commit), and a host gated by a route-level rule is denied to the shell
    entirely (because `CONNECT host:port` carries no method, path or body, and
    the proxy will not guess). Both are places where the vocabulary and the
    mechanism do not line up perfectly; say so rather than smoothing it over.
  - That the sandbox is a hard requirement with no host fallback — the fallback
    is the hole.
]

#todo[
  *13. Actions: the vocabulary, and the loop that produces a policy.* The
  chapter's central contribution and the direct analogue of markers. Cover:
  - The action registry: an expert-authored catalog of named, parameterized
    request and command shapes. Name, host or binary, and the rules it expands
    to. Show one entry in full and one policy generated from it.
  - Parameterization and tightening: a bare placeholder admits any value
    matching the registry's fragment, a bound one narrows to a literal. This is
    what lets one vocabulary item serve both "any repo" and "this repo" without
    the user ever seeing a regex.
  - Denial by omission: the catalog is an allow-list, so the dangerous operation
    is blocked because it was never named, not because someone anticipated it.
    The volume-delete case is the demonstration — `volumeDelete` is absent from
    the registry, and that absence is the defense. This is a strong point; make
    it explicitly, and pair it with its limit (a substring match on a GraphQL
    body stops an accident, not an adversary who bundles operations).
  - Extending actions from REST to shell commands: what an action over argv
    looks like, how `GIT_COMMIT(where=…)` decomposes into the flags it forbids,
    and why naming the command shape is tractable where naming the syscall
    footprint is not.
  - The authoring loop, which is the part that answers "where do task-specific
    policies come from": the agent drafts a proposal, the system renders it in
    the vocabulary, the user approves or refuses, the change is recorded. State
    clearly that the model is on the _authoring_ path and off the _enforcement_
    path, and that the policy file is not the agent's to write — the harness
    denies it at the tool layer and the sandbox denies it at the OS layer, so
    the proposal tool is the only route and every change leaves a record.
  #linebreak()
  _Figure still to draw, and the most valuable one in the thesis:_ a worked
  end-to-end example — prompt, agent-proposed action set, the approval dialog as
  the user sees it, the generated policy, and the denied call. One figure
  carrying all five steps would do more than any amount of prose. It is a
  fletcher diagram like @fig:component-overview; reuse that file's node helpers.
  _Figures placed:_ @fig:component-overview is redrawn for the sandbox-only
  design (the paper's version showed the MCP-server-modification story and is
  kept in `assets/` only for comparison), and the policy and synopsis listings
  below come from the paper's `example.typ`, highlighted by the copied
  `policy-lang-syntax.yaml`.
]

#ps.example-policy <fig:example-policy>

#ps.example-synopsis <fig:example-synopsis>

#todo[
  *14. Evaluation.* The design is further along than the evaluation, so write
  this section as a plan you then fill in. Structure:
  - The replay methodology: real agent sessions replayed against protection
    configurations, with divergence from the recorded transcript as the
    enforcement signal. Explain why divergence is the right oracle and what it
    cannot tell you.
  - The protection axis, which is already the right experimental design and
    should be stated as such: `none`, static analysis, coarse sandbox, and the
    action-based policy. The coarse-sandbox column is the one that carries the
    argument — it is the honest baseline that a reasonable engineer would build,
    and showing it either over- or under-blocks on the same scenarios is the
    empirical form of the vocabulary claim.
  - Scenario lineup: env-file exfiltration, sensitive data, git overreach,
    merge conflicts, PR/CI fixing, volume delete. Say which are accidents and
    which are attacks, and make sure there are positive controls — scenarios
    where the guardrail must _not_ block — or the discrimination claim is empty.
  - The questions to answer beyond block/allow: how many approval prompts a user
    faces per session, what registry coverage real sessions need, how often the
    agent's drafted policy is accepted unchanged, and overhead.
  - A user-facing evaluation of whether the vocabulary is actually legible.
    Without it the central claim rests on assertion; even a small study, or a
    structured argument about why one is impractical here, is better than
    silence.
  #linebreak()
  _Figure:_ the results table below is ported from the paper and still reads
  `assets/palsgraf/runs/results.csv`, so rerunning the experiments updates it.
  Two things to revisit: it covers only three scenarios, and the row the paper
  called "Hybrid approach" is labelled "Palsgraf" here, which is right for the
  thesis but means the row no longer matches the paper's text.
]

#ps.results-qualitative <tab:results-qualitative>
