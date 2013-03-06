library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#names of all studies
studyNames     <-  getStudyNames()
studyname      <-  "Aiba2005"

rmRowNames  <-  function(studyname, object){
  cat (studyname, " ")
  read.mat   <-  read.csv(paste0(dir.rawData, "/", studyname, "/", object, ".csv"),h=TRUE,stringsAsFactors=FALSE,check.names=FALSE,row.names=NULL)
  read.mat   <-  read.mat[,names(read.mat) != ""]
  write.csv(read.mat, paste0(dir.rawData, "/", studyname, "/", object, ".csv"), row.names=FALSE)
}

#All studies
d  <-  mapply(rmRowNames, studyNames, "dataNew")
e  <-  mapply(rmRowNames, studyNames, "dataMatchColumns")
