.PHONY: all
all: en-europass.pdf fr-europass.pdf es-europass.pdf en-moderncv.pdf fr-moderncv.pdf es-moderncv.pdf

.PHONY: install-deps
install-deps:
	-mkdir -p ~/texmf/tex/latex/
	-git clone git@github.com:paguiar/europecv2013.git ~/texmf/tex/latex/europecv2013
	-sudo apt-get install ghostscript texlive-latex-base ruby

%-moderncv.pdf.tex.erb: locale = $(shell echo $@ | cut -c 1-2)
%-moderncv.pdf.tex.erb: moderncv.pdf.tex.erb.erb
	echo $(locale)
	sed "s/CV_LOCALE/$(locale)/g" $< > $@

%-europass.pdf.tex.erb: locale = $(shell echo $@ | cut -c 1-2)
%-europass.pdf.tex.erb: europass.pdf.tex.erb.erb
	echo $(locale)
	sed "s/CV_LOCALE/$(locale)/g" $< > $@

# TODO Check specific yml for given language (and not all of them)
%.pdf.tex: %.pdf.tex.erb locales/*.yml
	erb -T - $< > $@

%.pdf: final_basename = $(basename $(basename $(notdir $<)))
%.pdf: %.pdf.tex
	pdflatex -jobname=$(final_basename) $<
	#bibtex $(basename $<)
	pdflatex -jobname=$(final_basename) $<
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$(final_basename)-compressed.pdf" $@

.PHONY: clean
clean: clean-soft
	-rm -rf *.pdf

.PHONY: clean-soft
clean-soft:
	-rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.out *.pdf.tex *.pdf.tex.erb
