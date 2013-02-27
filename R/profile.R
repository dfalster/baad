
library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#names of all studies
studyNames     <-  getStudyNames()

#import data
Rprof(tmp <- tempfile())
d<-loadStudies(studyNames, reprocess = TRUE, verbose = TRUE)
summaryRprof(tmp)
unlink(tmp)
