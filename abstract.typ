// Separate document: the abstract is not part of the dissertation and is
// not listed in its Contents. Final builds fail above 350 words / 2,450 chars.
#import "lib/brown-thesis.typ": abstract-page
#import "meta.typ": meta

#show: abstract-page.with(..meta)
#include "front/abstract.typ"
