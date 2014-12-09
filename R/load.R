rm(list=ls())
source('R/import.R')
source('R/packages.R')

#prepare new files for pre-import
NewStudies  <-  getStudyNames()
newS        <-  NewStudies[59]
makeDataImport(newS)
setUpFiles(newS)

#process all studies
d <- loadStudies(reprocess=TRUE)
