
library(testthat)
rm(list=ls())
source('R/import.R')
source("report/test-import-fun.R")

#Test single study
studyName     <-  "Aiba2005"
system(paste0("rm output/data/", studyName, ".csv"))
d<-importAndCheck(studyName, verbose=TRUE)
