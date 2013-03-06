library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#names of all studies
studyNames     <-  getStudyNames()
studyname      <-  "Rodriguez2003"


rep.var.in  <-  function(studyname){
  cat (studyname, " ")
  read.mat   <-  read.csv(paste0(dir.rawData, "/", studyname, "/", "dataMatchColumns.csv"),h=TRUE,stringsAsFactors=FALSE,check.names=FALSE,row.names=1)
  read.mat   <-  read.mat[,c("var_in_unchecked_names","method", "unit_in", "var_out","notes")]
  names(read.mat)  <-  c("var_in","method", "unit_in", "var_out","notes")
  write.csv(read.mat, paste0(dir.rawData, "/", studyname, "/", "dataMatchColumns.csv"))
}  


#one study
#rep.test  <-  rep.var.in("Aiba2005")
#All studies
d  <-  lapply(studyNames[39:length(studyNames)],rep.var.in)