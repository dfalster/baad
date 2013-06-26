rm(list=ls())
source('~/git/dataMashR/R/import.R')
source('R/import.R')  


#process all studies
d <- loadStudies(reprocess=TRUE)
