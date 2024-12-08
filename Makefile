.PHONY: all
all: en-moderncv.pdf fr-moderncv.pdf es-moderncv.pdf

%-moderncv.pdf.tex.erb: locale = $(shell echo $@ | cut -c 1-2)
%-moderncv.pdf.tex.erb: moderncv.pdf.tex.erb.erb
	echo $(locale)
	sed "s/CV_LOCALE/$(locale)/g" $< > $@

# TODO Check specific yml for given language (and not all of them)
%.pdf.tex: %.pdf.tex.erb locales/*.yml cv_i18n.rb
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