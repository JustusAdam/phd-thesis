# Imported figure sources

Source files for figures preserved from the two papers. The Typst wrappers that
place them are in `figures/paralegal.typ` and `figures/palsgraf.typ`; nothing in
`assets/` is edited, so re-copying from the paper repos is safe.

## `paralegal/` — from `paralegal-paper/osdi-25`

| file | placed as | note |
| --- | --- | --- |
| `paralegal-overview.pdf` | `pl.overview` | verbatim |
| `plume-altered.rs` | `pl.plume-listing` | retyped as a Typst code block, line-numbered |
| (CNL listings, `chapters/overview.tex`) | `pl.deletion-policies` | retyped, before/after pair |
| `plume-pdg.pdf` | — | superseded: `pl.plume-pdg` is now redrawn in Typst with fletcher; kept for comparison |
| `ide_plot.pdf` | `pl.runtime-interactive` | verbatim |
| `ci_plot.pdf` | `pl.runtime-ci` | verbatim |
| `per_controller_plot.pdf` | `pl.runtime-per-endpoint` | verbatim |
| `k_depth_plot.pdf` | `pl.adaptive-approximation` | verbatim |
| `plume-pdg.tex` | — | the TikZ source the PDF came from |

Defect found and fixed in the redraw: `plume-pdg.pdf` labels the function scope
`delete_user @ L8`, but `delete_user` is on line 11 of the listing. Every other
line reference (L13, L14, L15, L18, L20) checks out, so that one label was
stale. The Typst version says `L11`.

Still to port (LaTeX tables, retyping required): the bug table
(`chapters/case-studies.tex`), the applications table `fig:apps`
(`chapters/prototype.tex`), the IFC/CodeQL comparison `tab:results`
(`chapters/eval-related-work.tex`), and the PDG/CFG grammar `fig:grammar`
(`chapters/pdg.tex`).

## `palsgraf/` — from `JustusAdam/palsgraf-paper`

That paper is Typst, so these port directly.

| file | placed as | note |
| --- | --- | --- |
| `runs/results.csv` | `ps.results-qualitative` | the table reads the CSV, so rerunning the experiments updates it |
| `results-qual.typ` | — | the paper's original, kept for reference; the thesis version is self-contained |
| `figures.typ` | `ps.write-file-undisclosed`, `ps.write-file-sandboxed` | the motivating listings |
| `policy-lang-syntax.yaml` | used by `ps.example-policy`, `ps.example-synopsis` | `#set raw(syntaxes: ...)` highlighting |
| `haven-overview.pdf` | — | superseded: `ps.component-overview` is redrawn for the sandbox-only design; kept for comparison |
| `utils.typ` | — | the paper's helpers, kept for reference; nothing imports it |
| `Overview.pdf` | — | duplicate of `assets/Overview.pdf`, already used in ch. 2 |

Caveat on what remains: the `write_file` listings still depict the design where
the tool developer modifies the MCP server to accept a `SandboxConfig`. They are
kept because they state the problem well; the figure's caption says outright
that the chapter argues for confining the process instead.

The results table's last row was relabelled from the paper's "Hybrid approach"
to "Palsgraf", which suits the thesis but no longer matches the paper's prose.
