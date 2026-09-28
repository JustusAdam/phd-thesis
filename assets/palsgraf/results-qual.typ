#import "../../utils.typ": *
#import "@preview/subpar:0.2.2"

#let the-figure(scenarios) = {
  let (yes, no, good-yes, bad-no, good-no, bad-yes, good, bad) = table-syms
  set table.cell(align: center + horizon)
  let load-csv(path) = csv(path, row-type: dictionary) 
    .map(i => (i.tag + "-" + i.protection, i))
    .to-dict()
  let data = load-csv("../../runs/2026-04-11T12-09-37/results.csv")
  let header = (
    ([Unprotected], "none"),
    ([Global Sandbox], "coarse-sandbox"),
    ([Static Effect Detection], "static-analysis"),
    ([Haven], "hybrid"),
  )
  let is-action-allowed(i) = i.success == "true" and i.transaction-result != "deny"
  let get-results(scenario, protection, problem) = {
    let i = data.at("scenario-" + str(scenario) + "-" + problem + "-" + protection, default: none)
    if i == none {
      return [?]
    }
    
    let action-allowed = is-action-allowed(i)
    let is-good-outcome = action-allowed == (problem == "benign")
    let action-text = if action-allowed { [Allowed] } else { [Blocked] }
    let outcome-sym = if is-good-outcome { text(fill: green)[#yes] } else { text(fill: red)[#no] }
    
    text(size: 0.85em, hyphenate: false)[#outcome-sym \ #action-text]
  }
  let format-data(allowed, blocked) = header.map(((name, protection)) => {
    (name, 
      ..(1,2,3).map(scenario => {
        let i = data.at("scenario-" + str(scenario) + "-benign-" + protection, default: none)
        if i == none {
          return [?]
        }
        if is-action-allowed(i) {
          allowed
        } else {
          blocked
        }
      }).flatten()
    )
  }).flatten()
  let benigns = format-data(good-yes, bad-no)
  let problems = format-data(bad-yes, good-no)
  let the-stroke = .5pt
  let stroke-fn(x, y) = {
    (
      left: 
        if x == 1 { 2* the-stroke } 
        else if x != 0 { the-stroke },
      top: 
        if y == 1 { 2 * the-stroke }
        else if y != 0 { the-stroke },
      right: none,
      bottom: none,
    )
  }
  let table-header = table.header(
      [
        *Protection\ Mechanism*
      ], 
      ..scenarios.map(s => [*#s*])
    )
  let table-benign = table(columns: 4, stroke: stroke-fn,
    inset: (x: 5pt, y: 4pt),
    table-header,
    ..benigns
  )
  let table-problem = table(columns: 4, stroke: stroke-fn,
    inset: (x: 5pt, y: 4pt),
    table-header,
    ..problems
  )
  
  let actual = (
    ([Unprotected], "none"),
    ([Global Sandbox], "coarse-sandbox"),
    ([Static Effect Detection], "static-analysis"),
    ([Hybrid approach (this paper)], "hybrid"),
  ).map(((name, protection)) => {
    (name, 
      ..(1, 2, 3).map(scenario => 
        ("benign", "problem").map(problem => {
          let i = data.at("scenario-" + str(scenario) + "-" + problem + "-" + protection, default: none)
          if i == none {
            return [?]
          }
          
          let action-allowed = i.success == "true" and i.transaction-result != "deny"
          let is-good-outcome = action-allowed == (problem == "benign")
          let action-text = if action-allowed { [Allowed] } else { [Blocked] }
          let outcome-sym = if is-good-outcome { good-yes } else { bad-no }
          
          text(size: 1em, hyphenate: false)[#outcome-sym  #action-text]
        })
      ).flatten()
    )
  }).flatten()
  let num-cols = 5
  let the-stroke = .5pt
  let stroke-fn(x, y) = {
    (
      left: 
        if x == 1 { 2* the-stroke } 
        else if x != 0 { the-stroke },
      top: 
        if y == 2 { 2 * the-stroke }
        else if y != 0 { the-stroke },
      right: none,
      bottom: none,
    )
  }
  let variant-good = "Intended" // emoji.thumb.up
  let variant-bad = "Divergent"  // emoji.thumb.down
  let the-table(data) = table(columns: 7, stroke: stroke-fn,
    inset: (x: 3.4pt, y: 4pt),
    table.header(
      table.cell(rowspan: 2)[
        *Protection Mechanism*
      ], 
      ..scenarios.map(s => 
        table.cell(colspan: 2)[*#s*],
      ),
      ..scenarios.map(_ => 
        (
          [#variant-good], 
          [#variant-bad], 
        )
      ).flatten(),
    ),
    ..actual
  )
  [
    #figure(the-table(actual),
    caption: [
      Qualitative result of comparing all four protection mechanism setups, showing
      which scenario variants were Allowed or Blocked. #good-yes indicates the protection mechanism successfully achieved its
      aim, while #bad-no indicates it failed. Only the #approach
      catches all three divergent behaviors while allowing all intended ones.
    ],
    placement: top,
    scope: "parent",
  )
    <fig:results-qual>
]
  // subpar.grid(
  //   columns: 2,
  //   figure(table-benign,
  //     caption: [Results for benign scenario variants. #good-yes indicates the
  //     action was correctly allowed, #bad-no it was incorrectly denied.]
  //   ),
  //   figure(table-problem,
  //     caption:[Results for problematic scenario variants. #good-no indicates the
  //     action was correctly denied, #bad-yes it was unsafely allowed. 
  //     // hacky, but I need a gap here and don't want to figure out the clean solution
  //   ]
  //   ),
  //   gap: 5pt,
  //   caption: [
  //     Qualitative result of comparing all four protection mechanism setups, showing
  //     which scenario variants were Allowed or Blocked. #good[green] always indicates the protection mechanism successfully achieved its
  //     aim, while #bad[red] indicates it failed. Only #the-approach
  //     catches both divergent behaviors while allowing all intended ones.
  //   ],
  //   label: <fig:results-qual>,
  //   placement: top,
  //   scope: "parent",
  //   //figure-overrides: ("gap": 4pt)
  // )
}