
library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#Test single study
d<-loadStudy("Kohyama1987", verbose = TRUE)

#names of all studies
studyNames     <-  getStudyNames()

#import data
d<-loadStudies(studyNames, reprocess = TRUE, verbose = TRUE)
