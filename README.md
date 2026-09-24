# Brown University Ph.D. dissertation (Typst)

Unofficial. Structure adapted from `harvard-gsas-thesis-oat` (MIT); layout from
the Graduate School's dissertation guidelines and sample pages.

```
main.typ               dissertation (front matter + chapters + bib + appendices)
abstract.typ           separate abstract document (not part of the dissertation)
signature.typ          standalone signature page to sign and send in
meta.typ               title, names, dates: shared by all three
preamble.typ           import in every chapter; your macros go here
lib/brown-thesis.typ   the template
front/ chapters/ appendices/ refs.bib assets/
```

`make draft` / `make watch` / `make final` (PDF/A-2b) / `make verify` (veraPDF).

## What the template enforces

- US Letter; margins 1" top/bottom/right, 1.5" left (sample pages).
- Double spacing (true 2x pitch); single-spaced block quotes, captions,
  headings, footnotes, tables, code, bibliography, lists.
- Preliminary pages in required order: title (i, hidden), copyright (ii, hidden),
  signature, CV, preface & acknowledgments, contents, list of tables, list of
  illustrations; lowercase roman, centred ~3/4" from the bottom edge.
- Body in Arabic numerals from 1; no running headers; major divisions start a
  new page with centred upper-case headings 2" from the top edge.
- Abstract: separate PDF with the required heading line; final build fails
  above 350 words / 2,450 characters.
- Final build fails on any `todo[...]`.

## Check before submitting

- Title-page wording follows the long-standing `brownthesis.cls` convention;
  Brown publishes no dissertation title-page sample. Confirm with ETD@brown.edu.
- Fill in the current Dean of the Graduate School in `meta.typ`.
- Dates are the conferral date (Oct/Feb/May), also for the copyright year.
- `monochrome: true` turns off brand colour if the Graduate School objects.
