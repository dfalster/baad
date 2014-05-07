
all: ms.md ms.html

ms.md: ms.Rmd
	Rscript -e 'knitr::knit("$<", output = "$@")'

%.html: %.md
	pandoc $< -o $@
	#Rscript -e 'markdown::markdownToHTML("$<", "$@")'

clean:

.PHONY: all clean
