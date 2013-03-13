library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

getNewStudyNames  <-  function(){dir("ready-for-import")}
readyDir          <-  "ready-for-import"
#names of all studies
newStudies     <-  getNewStudyNames()
#single test
#newStudy       <-  newStudies[1]

a  <-  lapply(newStudies, makeDataImport)

#now edit the dataImportOptions.csv in each new folder accordingly.

a  <-  lapply(newStudies, setUpFiles)

dir.rawData   <-  "ready-for-import"
d<-addStudies(newStudies, reprocess = FALSE, verbose = TRUE)


