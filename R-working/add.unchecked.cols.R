library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#names of all studies
studyNames     <-  getStudyNames()
studyname      <-  "O'Grady2006"


loadData<-function(studyName,check.names=TRUE){
  #import options for data file
  import <-  read.csv(paste0(dir.rawData,"/",studyName,"/dataImportOptions.csv"), h=FALSE, row.names=1, stringsAsFactors=FALSE)   
  
  #brings in the original .csv
  raw     <-  read.csv(paste0(dir.rawData,"/",studyName,"/",import['name',]), h=(import['header',]=="TRUE"), skip=as.numeric(import['skip',]), stringsAsFactors=FALSE, check.names=check.names)
  raw
}



add.un.cols  <-  function(studyname){
  cat (studyname, " ")
  read.mat   <-  read.csv(paste0(dir.rawData, "/", studyname, "/", "dataMatchColumns.csv"),h=TRUE,stringsAsFactors=FALSE,check.names=FALSE,row.names=1)
  read.ori   <-  loadData(studyname,check.names=TRUE)
  read.new   <-  loadData(studyname,check.names=FALSE)
  namesMatch <-  match(read.mat$var_in,names(read.ori))
  read.mat$var_in_unchecked_names  <-  names(read.new)[namesMatch]
  k  <-  is.na(read.mat$var_in_unchecked_names)
  if(any(k)){
    read.mat$var_in_unchecked_names[k]  <-  read.mat$var_in[k]
  }
  write.csv(read.mat, paste0(dir.rawData, "/", studyname, "/", "dataMatchColumns.csv"))
}  
  
  
  
#All studies
d  <-  lapply(studyNames,add.un.cols)