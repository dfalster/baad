rm(list=ls())
source('R/packages.R')
source('R/import.R')
source('report/report-fun.R')

#names of all studies
studyNames     <-  getStudyNames()

#import data
d  <-  addStudies(studyNames, reprocess = FALSE, verbose = FALSE)

#Explore
alldata  <-  d$data

comparePlots(alldata)
