.PHONY: all
all: en-europass.pdf fr-europass.pdf es.pdf

.PHONY: install-deps
install-deps:
	-mkdir -p ~/texmf/tex/latex/
	-git clone git@github.com:paguiar/europecv2013.git ~/texmf/tex/latex/europecv2013
	-sudo apt-get install ghostscript texlive-latex-base ruby

%.pdf.tex: %.pdf.tex.erb
	erb -T - $< > $@

%.pdf: final_basename = $(basename $(basename $(notdir $<)))
%.pdf: %.pdf.tex
	pdflatex -jobname=$(final_basename) $<
	#bibtex $(basename $<)
	pdflatex -jobname=$(final_basename) $<
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$(final_basename)-compressed.pdf" $@

.PHONY: clean
clean: clean-soft
	-rm -rf *.pdf *.pdf.tex

.PHONY: clean-soft
clean-soft:
	-rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.out
