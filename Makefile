TARGETS=output/baad.rds

baad: output/baad.rds

ms: output/baad.rds
	make -C ms

output/baad.rds:
	Rscript build-baad.R

clean:
	rm $(TARGETS)
	make -C ms clean

install-dataMashR:
	R CMD INSTALL dataMashR

.PHONY: baad clean install-dataMashR
