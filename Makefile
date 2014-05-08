all: baad ms

baad: output/baad.rds

ms: ms/ms.html

ms/ms.html: output/baad.rds
	make -C ms

output/baad.rds:
	Rscript build-baad.R

clean:
	rm output/baad.rds
	make -C ms clean

install-dataMashR:
	R CMD INSTALL dataMashR

.PHONY: baad clean install-dataMashR
