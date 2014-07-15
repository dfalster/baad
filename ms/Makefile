TARGETS = ms.md ms.html

all: $(TARGETS)

ms.md: ms.Rmd MS-fun.R ../output/baad.rds refs.bib
	Rscript -e 'library(methods); knitr::knit("$<", output = "$@")'

%.html: %.md
	Rscript -e 'rmarkdown::render("$<", "html_document")'

clean:
	rm -f $(TARGETS)

.PHONY: all clean
