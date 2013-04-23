rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#names of all studies
studyNames  <-  getStudyNames()
newStudies  <-  studyNames[c(18,50)]

a  <-  lapply(newStudies, makeDataImport)

#edit the dataImportOptions.csv in each new folder accordingly.
#after doing that, create all the files necessary for the data processing
b  <-  lapply(newStudies, setUpFiles)

dir.rawData   <-  "ready-for-import"
d<-addStudies(newStudies, reprocess = FALSE, verbose = TRUE)



