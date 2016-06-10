# ARGS is an environment variable, call make such as (to build the spanish version):
# $ ARGS=spa make
all:
	pdflatex $(ARGS)
	mv $(ARGS).pdf cv_pedro_aguiar.pdf
bib:
	pdflatex $(ARGS)
	bibtex $(ARGS)
	pdflatex $(ARGS)
	mv $(ARGS).pdf cv_pedro_aguiar.pdf
clean:
	(rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.out)
trim:
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=tmp.pdf cv_pedro_aguiar.pdf
	mv tmp.pdf cv_pedro_aguiar.pdf
