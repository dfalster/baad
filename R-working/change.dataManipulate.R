library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#names of all studies
studyNames     <-  getStudyNames()
studyname      <-  "Coll2008"

change.manin  <-  function(studyname){
  cat (studyname, " ")
  fileName  <-  paste0(dir.rawData, "/", studyname, "/dataManipulate.R")
  file.in   <-  readChar(fileName, file.info(fileName)$size)
  
  if(file.in != "" | !is.na(file.in)){
    read.mat  <-  read.csv(paste0(dir.rawData, "/", studyname, "/dataMatchColumns.csv"),h=TRUE,stringsAsFactors=FALSE,check.names=FALSE,row.names=1)
    orig      <-  unlist(lapply(read.mat$var_in, function(x){paste0("$",x)}))
    new       <-  unlist(lapply(read.mat$var_in_unchecked_names, function(x){paste0('[["',x,'"]]')}))
    file.out  <-  file.in  
  
    for(x in 1:length(orig)){
      file.out  <-  gsub(orig[x],new[x],file.out,fixed=TRUE)
    }
    
    write(file.out, paste0("/Users/barneche/allometry/baad/", studyname))
    #write(file.out, paste0(dir.rawData, "/", studyname, "/dataManipulate.R"))

  }
}  



#All studies
d  <-  lapply(studyNames,change.manin)


change.name <- function(x){
  file.rename(paste0(x,"test.file.out.R"), paste0(x,".R"))
}

a  <-  lapply(studyNames,change.name)


change.rfile  <-  function(studyname){
  cat (studyname, " ")
  fileName  <-  paste0(studyname, ".R")
  file.in   <-  readChar(fileName, file.info(fileName)$size)
  write(file.in, paste0(dir.rawData, "/", studyname, "/dataManipulate.R"))
}

b  <-  lapply(studyNames,change.rfile)
