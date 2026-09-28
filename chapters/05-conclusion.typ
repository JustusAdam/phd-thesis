#import "../preamble.typ": *

= Related Work and Conclusion <ch:conclusion>

#todo[
  *15. Related work, then the synthesis.* Two jobs in one chapter (split it
  later if it grows).
  - _Related work_ organized by the thesis's own axis rather than by technique:
    for each system, who authors the policy and in what vocabulary. Static
    analysis and IFC (Jif, HLIO, FlowDroid, DroidSafe, Resin, Jacqueline,
    RuleKeeper, PrivGuard, Sesame, Riverbed, MirChecker, CodeQL); agent defenses
    (CaMeL, Fides, ACE, Progent, IsolateGPT, Conseca); confinement (bubblewrap,
    Seatbelt, RLBox, NaCl, Ryoan, BinWrap, Try/semisolates); and the deployed
    status quo of permission prompts. The table you want is
    system × policy author × vocabulary × enforcement point.
  - _Synthesis:_ return to the thesis statement and argue it from the two
    chapters. The strongest version of the argument is the contrast between
    them: the same idea at compile time with a trusted developer, and at runtime
    with an untrusted model, works both times — which is evidence the idea is
    about vocabularies and not about either setting.
  - _Limits of the claim, stated by you:_ the vocabulary must be authored by
    someone, and neither system says where that expertise comes from at scale or
    what happens when the registry or marker set is incomplete. Registry
    coverage is the honest open problem of @ch:palsgraf; say so.
  - _Future work:_ inferring or synthesizing vocabulary from code and from
    session corpora; reusing Paralegal's analysis to verify that a tool
    implementation matches its declared action; sharing and trusting registries
    across organizations; and what changes when the agent, not a person,
    is the one reading the policy.
]
