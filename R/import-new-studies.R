rm(list=ls())
source('R/import.R')

#names of all studies
studyNames  <-  getStudyNames()
newStudies  <-  studyNames[c(18,50)]

a  <-  lapply(newStudies, makeDataImport)

#edit the dataImportOptions.csv in each new folder accordingly.
#after doing that, create all the files necessary for the data processing
b  <-  lapply(newStudies, setUpFiles)

d  <-  addStudies(newStudies, reprocess = TRUE, verbose = TRUE)



