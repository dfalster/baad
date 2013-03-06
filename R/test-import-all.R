
library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#Test single study
d<-importAndCheck("O'Hara0000", verbose=TRUE)
#names of all studies
studyNames     <-  getStudyNames()

#import data
d<-loadStudies(studyNames, reprocess = TRUE, verbose = TRUE)
