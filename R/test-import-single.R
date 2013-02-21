
library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#Test single study
studyName     <-  "Aiba2005"
system(paste0("rm output/data/", studyName, ".csv"))

data<-importData(studyName)

compareOldNew(studyName)

cat("\n")
