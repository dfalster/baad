TARGETS=output/baad.rds

baad: output/baad.rds

output/baad.rds:
	Rscript build-baad.R

clean:
	rm $(TARGETS)

install-dataMashR:
	R CMD INSTALL dataMashR

.PHONY: baad clean install-dataMashR
