all: egpaper

egpaper:
	pdflatex egpaper
	bibtex egpaper
	pdflatex egpaper
	pdflatex egpaper


clean:
	rm *.log *.dvi *.aux *.brf *.out *.bbl $(INCLUDED)
