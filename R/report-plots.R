rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source('R/report-per-study-fun.R')
source('R/report-plots-fun.R')
source('R/packages.R')

#names of all studies
studyNames     <-  getStudyNames()

#import data
d  <-  addStudies(studyNames, reprocess = FALSE, verbose = FALSE)

#Explore
alldata  <-  d$data

comparePlots(alldata, pdf=TRUE)
