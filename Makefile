TYPST ?= typst
OUT    := build

.PHONY: draft watch final verify clean

# Draft: watermark, todo() rendered, abstract limits reported not enforced.
draft: | $(OUT)
	$(TYPST) compile --input draft=true main.typ $(OUT)/thesis-draft.pdf

watch: | $(OUT)
	$(TYPST) watch --input draft=true main.typ $(OUT)/thesis-draft.pdf

# Final: PDF/A-2b; fails on leftover todo() or an over-long abstract.
final: | $(OUT)
	$(TYPST) compile --pdf-standard a-2b main.typ $(OUT)/thesis.pdf
	$(TYPST) compile --pdf-standard a-2b abstract.typ $(OUT)/abstract.pdf
	$(TYPST) compile signature.typ $(OUT)/signature.pdf

# Needs veraPDF (https://verapdf.org) on PATH.
verify: final
	verapdf --flavour 2b $(OUT)/thesis.pdf $(OUT)/abstract.pdf

$(OUT):
	mkdir -p $(OUT)

clean:
	rm -rf $(OUT)
