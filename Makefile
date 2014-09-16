all: baad ms reports

BAAD=output/baad.rds

baad: ${BAAD}

ms: ms/ms.html

ms/ms.html: ${BAAD}
	make -C ms

reports: output/reports/tmp

output/reports/tmp:
	make -C reports

${BAAD}:
	Rscript build-baad.R

clean:
	rm -fr output/baad.rds output/cache output/baad
	make -C ms clean
	make -C reports clean


install-dataMashR:
	R CMD INSTALL dataMashR

test:
	Rscript -e "library(methods); testthat::test_file('testing.R')"

check-eol:
	./scripts/check_line_endings.sh csv

.PHONY: baad clean install-dataMashR test check-eol test-dat
