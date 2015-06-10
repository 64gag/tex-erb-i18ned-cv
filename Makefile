all:
	pdflatex spa
	bibtex spa
	pdflatex spa
	pdflatex spa
	mv spa.pdf CV_Pedro_Aguiar.pdf
	(rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.out)
pdf:
	pdflatex spa
	bibtex spa
	pdflatex spa
	pdflatex spa
	mv spa.pdf CV_Pedro_Aguiar.pdf
	(rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.out)
clean:
	(rm -rf *.ps *.log *.dvi *.aux *.*% *.lof *.lop *.lot *.toc *.idx *.ilg *.ind *.bbl *.blg *.out)
trim:
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=tmp.pdf CV_Pedro_Aguiar.pdf
	mv tmp.pdf CV_Pedro_Aguiar.pdf
