.PHONY: all
all: eng-europass.pdf fra-europass.pdf spa.pdf

.PHONY: install-deps
install-deps:
	-mkdir -p ~/texmf/tex/latex/
	-git clone git@github.com:paguiar/europecv2013.git ~/texmf/tex/latex/europecv2013
	-sudo apt-get install ghostscript texlive-latex-base

%.pdf: %.tex
	pdflatex $<
	#bibtex $(basename $<)
	pdflatex $<
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$(basename $<)-compressed.pdf" $@

.PHONY: clean
clean: clean-soft
	-rm -rf *.pdf

.PHONY: clean-soft
clean-soft:
	-rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.out
