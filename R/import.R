

source("R/checkPackage.R")
sapply(c('bibtex', 'devtools', 'maps', 'mapdata', 'gdata', 'smatr', 'plyr'), checkPackage)
rm(checkPackage)

# Use local dataMashR if it exists
if(!file.exists("lib/dataMashR")){
	warning("We recommend you install dataMashR in local directory before proceeding")
} else {
  .libPaths(c("lib", .libPaths()))  # will cause us to use local version of dataMashR
}

library(dataMashR)

