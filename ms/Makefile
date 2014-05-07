TARGETS = ms.md ms.html

all: $(TARGETS)

ms.md: ms.Rmd
	Rscript -e 'knitr::knit("$<", output = "$@")'

%.html: %.md
	Rscript -e 'markdown::markdownToHTML("$<", "$@", stylesheet="stylesheet.css")'

clean:
	rm -f $(TARGETS)

.PHONY: all clean
