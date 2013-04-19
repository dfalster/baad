
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source('R/report-fun.R')
source('R/packages.R')

#names of all studies
studyNames     <-  getStudyNames()

#import data
d<-addStudies(studyNames, reprocess = FALSE, verbose = FALSE)


famnames <- sapply(species, tax_name, get = "family", USE.NAMES = F)
