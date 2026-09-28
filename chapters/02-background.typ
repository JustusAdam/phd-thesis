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
are pointers. Which value a given pointer may refer to, and therefore whether
one of them could be sensitive or not, depends on all parts of the program that
may modify pointer. This is called alias-analysis and unlike many other parts of
dataflow analysis it is a non-local analysis, meaning it cannot be performed
for one function alone, but must take into account all of its callers. This
leads to an explosion of the state space.

== Agentic AI

#figure(
  image("../assets/Overview.pdf"),
  caption: [
      An agentic AI application uses an interpreter to call tools requested by an LLM
  ]
)

The basic architecture or agentic loops is remarkably simple and, crucially, has
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


// Numbering restarts per chapter: see @tab:results in @ch:intro versus the next
// figure.

// #figure(
//   rect(width: 50%, height: 1in, stroke: palette.gray),
//   caption: [Numbered 2.1.],
// )
