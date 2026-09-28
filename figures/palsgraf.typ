// Figures for @ch:palsgraf, preserved from the Palsgraf paper
// (JustusAdam/palsgraf-paper). That paper is Typst, so these port directly;
// sources are in `assets/palsgraf/`.
//
// Deliberately self-contained: the paper's `utils.typ` is kept in `assets/` for
// reference, but nothing here imports it, so the thesis has one less thing that
// can drift.

#import "../lib/brown-thesis.typ": palette
#import "@preview/codly:1.3.0"
#import "@preview/subpar:0.2.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "util.typ": subfig-numbering, tight as _tight

#let _problem = palette.red-screen
#let _added = rgb("#1F7A1F")

// ---------------------------------------------------------------------------
// Component overview, redrawn for the sandbox-only design.
//
// The paper's drawing (`assets/palsgraf/haven-overview.pdf`) still shows tool
// developers modifying the MCP server to accept a `SandboxConfig`, and a
// `Synopsis` produced by a static analyzer. Neither is part of the sandbox-only
// story, so this is a redraw rather than a port. What it keeps is the thing the
// paper's version got right and readers get backwards: which side authors the
// policy.
// ---------------------------------------------------------------------------
#let _trusted-fill = palette.gold.lighten(80%)
#let _untrusted-fill = palette.gray.lighten(75%)

#let _box(pos, body, fill: none, ..rest) = node(
  pos,
  body,
  shape: rect,
  fill: fill,
  stroke: 0.5pt + palette.brown,
  inset: 6pt,
  ..rest,
)

#let _arrow = (stroke: 0.6pt + palette.brown, marks: "-|>")

#let component-overview = figure(
  kind: image,
  supplement: [Figure],
  block(width: 100%, {
    set par(justify: false)
    set text(size: 0.9em)
    diagram(
      spacing: (15mm, 9mm),
      node-inset: 5pt,

      // The group labels get their own nodes, one row above each group, and
      // the enclosure takes them in --- putting the label inside the enclosing
      // node instead lands it on top of the first box.
      node((0, -0.4), text(size: 0.85em, fill: palette.gray)[_client (trusted)_]),
      node((1.7, -0.4), text(size: 0.85em, fill: palette.gray)[_untrusted_]),

      // --- trusted client ------------------------------------------------
      _box((0, 0))[LLM],
      _box((0, 1))[Interpreter],
      _box((0, 2), fill: _trusted-fill)[policy engine],
      _box((0, 3), fill: _trusted-fill)[action catalog],
      _box((-1.15, 1))[User],

      node(
        enclose: ((0, -0.4), (0, 0), (0, 1), (0, 2), (0, 3)),
        stroke: (dash: "dashed", paint: palette.gray, thickness: 0.5pt),
        inset: 8pt,
        snap: -1,
      ),

      edge((0, 0), (0, 1), .._arrow),
      edge((0, 1), (0, 2), .._arrow, label: text(size: 0.8em)[every effect]),
      edge((0, 3), (0, 2), .._arrow, label: text(size: 0.8em)[names]),
      edge((-1.15, 1), (0, 2), .._arrow, bend: -20deg, label: text(size: 0.8em)[approves]),

      // --- untrusted side -------------------------------------------------
      _box((1.7, 1), fill: _untrusted-fill)[tool / shell command],
      _box((1.7, 2), fill: _untrusted-fill)[spawned process],

      node(
        enclose: ((1.7, -0.4), (1.7, 1), (1.7, 2)),
        stroke: (dash: "dashed", paint: palette.gray, thickness: 0.5pt),
        inset: 8pt,
        snap: -1,
      ),

      edge((0, 2), (1.7, 1), .._arrow, label: text(size: 0.8em)[admit / refuse]),
      edge((1.7, 1), (1.7, 2), .._arrow),

      // --- the enforcement boundary ---------------------------------------
      _box((1.7, 3.2), fill: _trusted-fill)[sandbox: mounts #sym.plus egress proxy],
      edge((0, 2), (1.7, 3.2), .._arrow, bend: 18deg, label: text(size: 0.8em)[configures]),
      edge((1.7, 3.2), (1.7, 2), .._arrow, label: text(size: 0.8em)[confines]),
    )
  }),
  caption: [
    Palsgraf's components and trust boundaries, which are easy to invert. The
    client is trusted and is the only party that authors policy; the user
    approves it in the vocabulary of the action catalog. Everything the model
    asks for is mediated by the interpreter, and anything that escapes the
    interpreter --- a spawned process, most of all --- is confined by a sandbox
    the client configured, not by cooperation from the code being run.
  ],
)

// ---------------------------------------------------------------------------
// The motivating example: a tool whose documented effect is not its only one.
// From `chapters/figures.typ`.
// ---------------------------------------------------------------------------
#let write-file-undisclosed = figure(
  _tight(codly.local(
    annotation-format: none,
    highlights: (3, 4, 5).map(l => (line: l, start: 1, end: none, fill: _problem)),
    annotations: (
      (
        start: 3,
        end: 5,
        content: block(width: 4.6em, text(size: 0.7em, fill: _problem)[undisclosed]),
      ),
    ),
    ```python
    @tool(description="Writes `content` to file at `path`")
    def write_file(self, path: str, content: str):
      self.metrics.send({
        'method': "write_file",
        'bytes': len(content) })
      with open(path, "w") as f:
        f.write(content)
    ```,
  )),
  caption: [The tool as written: the metrics upload is not in its description.],
)

#let write-file-sandboxed = figure(
  _tight(codly.local(
    annotation-format: none,
    highlights: (4, 9).map(l => (line: l, start: 1, end: none, fill: _added)),
    ```rust
    #[tool(description = "Writes `content` to the file at `path`")]
    fn write_file(&self, path: &Path, content: String,
       // injected at the client by the protection system
       scfg: SandboxConfig
    ) {
      self.metrics.send(json!({
        method: "write_file",
        bytes: content.len() }));
      sandbox::write(path, content, scfg).unwrap();
    }
    ```,
  )),
  caption: [The same tool with a fine-grained sandbox.],
)

// The tightening has to sit on the grid, not on each sub-listing: subpar
// re-wraps each one in its own `figure`, and the template's
// `show figure: single-spaced` then re-applies the 1.4em block spacing inside.
#let write-file-example = _tight(subpar.grid(
  ..subfig-numbering,
  columns: 1,
  row-gutter: 10pt,
  write-file-undisclosed, <fig:write-file-undisclosed>,
  write-file-sandboxed, <fig:write-file-sandboxed>,
  label: <fig:write-file-example>,
  caption: [
    An MCP tool for file creation. In @fig:write-file-undisclosed the
    implementation performs an undisclosed metrics upload in addition to the
    documented file write; the description is the only thing the model --- or
    the user approving its use --- gets to see.
    @fig:write-file-sandboxed adds a fine-grained sandbox whose configuration is
    injected by the trusted client rather than supplied by the server. Note that
    this is the design in which the tool developer cooperates; this chapter
    argues for confining the process instead, precisely because cooperation
    cannot be assumed.
  ],
))

// ---------------------------------------------------------------------------
// A policy and a synopsis, in the policy language. From `chapters/example.typ`;
// highlighting comes from the syntax file copied alongside.
// ---------------------------------------------------------------------------
// Policies are not referenced by line, so the numbers would be noise.
#let _policy(body) = _tight(codly.local(number-format: none, {
  set raw(syntaxes: "../assets/palsgraf/policy-lang-syntax.yaml", lang: "policy")
  body
}))

#let example-policy = figure(
  _policy[
    ```
    deny(all)
    allow(net:write)
    intent(file-edit) -> allow(fs:write in "~/workspace")
    context(sensitive-data) -> deny(net:write)
    ```
  ],
  caption: [An example policy for the file-editing tool.],
)

#let example-synopsis = figure(
  _policy[
    ```
    input(path) -> effect(fs:write)
    input(content) -> effect(fs:write)
    input(content) -> effect(net:write)
    ```
  ],
  caption: [
    The synopsis static analysis derives for the `write_file` tool: which of the
    tool's inputs reach which effects. The undisclosed upload shows up as
    `content` reaching a network write.
  ],
)

// ---------------------------------------------------------------------------
// Qualitative results. Ported from `chapters/figures/results-qual.typ`; it
// reads the experiment output, so rerunning the experiments updates the table.
// ---------------------------------------------------------------------------
#let _yes = text(sym.checkmark, weight: "bold")
#let _no = text(sym.crossmark, weight: "bold")
#let _good(body) = text(fill: green.darken(20%), body)
#let _bad(body) = text(fill: palette.red-screen, body)

#let results-qualitative = {
  let data = csv("../assets/palsgraf/runs/results.csv", row-type: dictionary)
    .map(i => (i.tag + "-" + i.protection, i))
    .to-dict()

  let scenarios = ([`.env` file], [Sensitive code], [`git push`])
  let mechanisms = (
    ([Unprotected], "none"),
    ([Global sandbox], "coarse-sandbox"),
    ([Static effect detection], "static-analysis"),
    ([Palsgraf], "hybrid"),
  )

  let cell(scenario, protection, variant) = {
    let i = data.at("scenario-" + str(scenario) + "-" + variant + "-" + protection, default: none)
    if i == none { return [?] }
    let allowed = i.success == "true" and i.transaction-result != "deny"
    let correct = allowed == (variant == "benign")
    let sym = if correct { _good(_yes) } else { _bad(_no) }
    text(hyphenate: false)[#sym #if allowed [Allowed] else [Blocked]]
  }

  let body = mechanisms.map(((name, protection)) => (
    name,
    ..(1, 2, 3).map(s => ("benign", "problem").map(v => cell(s, protection, v))).flatten(),
  )).flatten()

  let s = 0.5pt
  let stroke-fn(x, y) = (
    left: if x == 1 { 2 * s } else if x != 0 { s },
    top: if y == 2 { 2 * s } else if y != 0 { s },
    right: none,
    bottom: none,
  )

  figure(
    kind: table,
    supplement: [Table],
    block(width: 100%, {
      set text(size: 0.9em)
      set table.cell(align: center + horizon)
      table(
        columns: 7,
        stroke: stroke-fn,
        inset: (x: 3.4pt, y: 4pt),
        table.header(
          table.cell(rowspan: 2)[*Protection mechanism*],
          ..scenarios.map(s => table.cell(colspan: 2)[*#s*]),
          ..scenarios.map(_ => ([Intended], [Divergent])).flatten(),
        ),
        ..body,
      )
    }),
    caption: [
      Which scenario variants each protection mechanism allowed or blocked.
      #_good(_yes) marks the intended outcome, #_bad(_no) a failure. The global
      sandbox is the honest baseline --- a policy a careful engineer would write
      without per-task knowledge --- and it fails in both directions, blocking
      intended work in one scenario and admitting divergent effects in the
      others. Only the per-task policy separates them everywhere.
    ],
  )
}
