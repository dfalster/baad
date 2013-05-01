rm(list=ls())
source('R/packages.R')
source('R/Biomass-fun.R')
source('R/import-fun.R')
source('R/report-fun.R')

#names of all studies
studyNames     <-  getStudyNames()

#import data
d  <-  addStudies(studyNames, reprocess = FALSE, verbose = FALSE)

#Explore
alldata  <-  d$data

comparePlots(alldata)
