INSTALLLATEX  = SHZBLBook
PDF       = $(INSTALLLATEX).pdf
REQUIRE   = $(INSTALLLATEX).tex #$(wildcard ./part/*.tex) #$(wildcard ./appendix/*.tex)
TEMP      = $(INSTALLLATEX).xdv $(INSTALLLATEX).aux $(INSTALLLATEX).log $(INSTALLLATEX).toc $(INSTALLLATEX).out $(INSTALLLATEX).synctex.gz \
			$(INSTALLLATEX).bbl $(INSTALLLATEX).blg \
            #$(wildcard ./part/*.aux) #$(wildcard ./appendix/*.aux)

TEX       = xelatex
MODE      = -synctex=1
NOPDFMODE = -synctex=1 --no-pdf

all: $(PDF)

$(PDF): $(REQUIRE)
	$(TEX) $(NOPDFMODE) $(INSTALLLATEX)
	$(TEX) $(MODE) $(INSTALLLATEX)

allclean:
	rm $(PDF) $(TEMP)

clean:
	rm $(TEMP)

.PHONY: all clean allclean
