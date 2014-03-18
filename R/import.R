

source("R/checkPackage.R")
sapply(c('bibtex', 'devtools', 'maps', 'mapdata', 'gdata', 'smatr'), checkPackage)
rm(checkPackage)


.libPaths(c("lib", .libPaths()))  # will cause us to use local version of dataMashR

if(!file.exists("lib/dataMashR")){
	warning("We recommend you install dataMashR in local directory before proceeding")
}

library(dataMashR)

