#let term(name, plural: none, article: "a", the: "the") = {
  let make-title(s) = s.replace(regex("\b\w"), c => upper(c.text))
  let make-upper(s) = s.replace(regex("\b\w"), c => upper(c.text), count: 1)
  let title = make-title(name)
  //let The = make-upper(the)
  let Name = make-upper(name)
  (
    it: name,
    It: Name,
    title: title,
    s: if plural == none { name + "s" } else { plural },
    S: if plural == none { Name + "s" } else { make-upper(plural) },
    a: article + " " + name,
    A: make-upper(article) + " " + make-title(article),
    // the: the + " " + name,
    // The: The + " " + name,
    // The-title: The + " " + name,
  )
}

#let system = [Palsgraf]
#let lang = [`pal`]
#let approach = term("hybrid approach")
#let synopsis = term("synopsis", plural: "synopses")
#let guardrail = [protection]
#let guardrail-framework = [protection mechanism]
#let guardrails = [protections]
#let guardrail-frameworks = [protection mechanisms]
#let protection = [protection]
#let protection-mechanism = [protection mechanism]
#let protection-mechanisms = [protection mechanisms]
#let applications = [agentic AI applications]
#let Applications = [Agentic AI applications]
#let application = [agentic AI application]
#let Application = [Agentic AI application]

#let peff = term("protocol effects")
#let papp = term("protocol program")

#let exsys = term("external system")

#let proxy = term("MITM proxy")
#let broker = term("command broker")

#let gt = term("generic command")

#let show-comments = true

#let to-review(content) = if show-comments {
  set text(fill: olive)
  content
} else { content }

#let todo(content) = if show-comments {
  set text(fill: red)
  content
} else { content }

#let justus(who: "J", color: green, content) = if show-comments { 
  set text(fill: color)
  [\[#who\]: ] + content
} else {}

#let malte = justus.with(who: "MS", color: blue)
#let deepti = justus.with(who: "D", color: orange)
#let yuchen =justus.with(who: "Y", color: purple)
#let alex = justus.with(who: "A", color: aqua)
#let nikos = justus.with(who: "N", color: teal)
#let matt = justus.with(who: "MM", color: yellow)

// A helper that will add line numbers to a listing. Use as
// #show raw.line: show-line-numbers
// before a listing. Beware that this will apply to the whole 
// scope afterwards
#let show-line-numbers(it) = {
  [#it.number ] + it
}

#let transpose(arr) = {
  let out = range(arr.at(0).len()).map(_ => ())
  for (x, row) in arr.enumerate() {
    for (y, elem) in row.enumerate() {
      out.at(y).push(elem)
    }
  }
  out
}

#let inline-colorbox(fill: white, text-fill: black, content) = {
  let inset = .2em
  box(rect(fill:fill, text(fill:text-fill, content), inset: (x: inset, y: 0pt), outset:(bottom: inset)))
}

#let table-syms = {
  let table-syms-base = (
    good: text.with(fill: green),
    bad: text.with(fill: red),
    
    low: text(sym.arrow.b, weight: "bold"),
    high: text(sym.arrow.t, weight: "bold"),
    yes: text(sym.checkmark, weight: "bold"),
    no: text(sym.crossmark, weight: "bold"),
  )
  let (good, yes, bad, no, low, high) = table-syms-base
  
  (
    ..table-syms-base,
    good-yes: good(yes),
    bad-no: bad(no),
    good-no: good(no),
    bad-yes: bad(yes),
  
    good-low: good(low),
    bad-high: bad(high),
    mid-warn: text("!", weight: "bold", fill: yellow),
  )
}

#let inline-heading(title, body) = [
  #set par(first-line-indent: 5pt)
  *#title.* #body
]