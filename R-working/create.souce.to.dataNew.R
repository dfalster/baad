library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#names of all studies
studyNames     <-  getStudyNames()
studyname      <-  "Delagrange2004"
add.source.to.dataNew  <-  function(studyname){
  cat (studyname, " ")
  read.in   <-  read.csv(paste0(dir.rawData, "/", studyname, "/", "dataNew.csv"),h=TRUE,stringsAsFactors=FALSE,check.names=FALSE)
  if(dim(read.in)[1]!=0){
    read.in$source  <-  "from paper[D Barneche]"
  } else {
    read.in[1,]     <-  NA
    read.in$source  <-  NA
    read.in         <-  read.in[-1,]
  }
  write.csv(read.in, paste0(dir.rawData, "/", studyname, "/", "dataNew.csv"))
}

#All studies
d  <-  lapply(studyNames,add.source.to.dataNew)
