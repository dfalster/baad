rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source('R/report-fun.R')
source('R/packages.R')

#names of all studies
studyNames     <-  getStudyNames()

#import data
d  <-  addStudies(studyNames, reprocess = FALSE, verbose = FALSE)

#create dataNew.csv files for authors to fill in
z  <-  lapply(studyNames, function(x){generateDataNew(d$data, x)})

#for each study, put variable.definition, contactInfo and Reference in the email folder
y  <-  lapply(studyNames, function(x){emailFiles(d$data, x)})

#markdown report: needs package 'knitr' installed (added to packages.R; RAD)
studyReportMd(d, "Ilomaki2003")
studyReportMd(d, "Parviainen1999")

l  <-  lapply(studyNames, function(x){studyReportMd(d, x)})
