TEX := icai2026-peter-saghelyi
PDF := $(TEX).pdf

.DEFAULT_GOAL := pdf

.PHONY: pdf clean clean-all

pdf: $(PDF)

$(PDF): $(TEX).tex references.bib icai2026.cls
	latexmk -pdf -interaction=nonstopmode -halt-on-error -file-line-error $(TEX).tex

clean:
	latexmk -c $(TEX).tex

clean-all:
	latexmk -C $(TEX).tex
