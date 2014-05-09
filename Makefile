# The database itself
BAAD=output/baad.rds

all: baad ms

baad: ${BAAD}

ms: ms/ms.html

ms/ms.html: ${BAAD}
	make -C ms

${BAAD}:
	Rscript build-baad.R

clean:
	rm ${BAAD}
	make -C ms clean

install-dataMashR:
	R CMD INSTALL dataMashR

test: ${BAAD}
	make -C tests

check-eol:
	./scripts/check_line_endings.sh csv

.PHONY: baad clean install-dataMashR test check-eol
