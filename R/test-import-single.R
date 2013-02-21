
library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#Test single study
studyName     <-  "Baltzer2007"

#system(paste0("rm output/data/", studyName, ".csv"))

data<-importData(studyName, verbose=TRUE)

compareOldNew(studyName)

cat("\n")
