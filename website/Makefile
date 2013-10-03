all: index.html

index.md: index.Rmd
	Rscript -e "require(knitr); require(ascii, quietly =TRUE);  knit('$<', '$@');"

%.html: %.md
	pandoc $< -o $@

clean:
	rm -f index.md
