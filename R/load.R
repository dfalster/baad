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


# Post-process.
dat <- postProcessAllom(d$data)
#saveRDS(dat, "cache/allomdata_post.rds")


