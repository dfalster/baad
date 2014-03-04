rm(list=ls())
source('R/import.R')  

#identify new studies
newStudies  <-  identifyNewStudies()
if(length(newStudies) > 0){
  lapply(newStudies, makeDataImport)
}
if(length(newStudies) > 0){
  lapply(newStudies, setUpFiles, quiet=FALSE)
}

#process all studies
d <- loadStudies(reprocess=TRUE)


# To make sure variable types are the same as in the config/variableDefinitions file, do;
#d$data <- fixType(d$data)