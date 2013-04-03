rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source('R/report-fun.R')
source('R/packages.R')

#names of all studies
studyNames     <-  getStudyNames()

#import data
d<-addStudies(studyNames, reprocess = FALSE, verbose = FALSE)

changeMetaData  <-  function(study){
  fileName   <-  paste0(dir.rawData, "/", study, "/studyMetadata.txt")
  open.meta  <-  readChar(fileName, file.info(fileName)$size)
  re         <-  "(+[[:punct:]]+[[:alpha:]]+[[:punct:]])"
  unname(sub(re, "", open.meta))
}