all: baad ms

BAAD=output/baad.rds

baad: ${BAAD}

ms: ms/ms.html

ms/ms.html: ${BAAD}
	make -C ms

${BAAD}:
	Rscript build-baad.R

clean:
	rm -fr output/baad.rds output/cache output/baad
	make -C ms clean

install-dataMashR:
	R CMD INSTALL dataMashR

test: ${BAAD}
	make -C tests

check-eol:
	./scripts/check_line_endings.sh csv

.PHONY: baad clean install-dataMashR test check-eol
