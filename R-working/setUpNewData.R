library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

getNewStudyNames  <-  function(){dir("ready-for-import")}
readyDir          <-  "ready-for-import"
#names of all studies
newStudies     <-  getNewStudyNames()
#single test
#newStudy       <-  newStudies[1]

#first create a dataImportOptions.csv for each new study
makeDataImport  <-  function(newStudy){
  impo      <-  data.frame(name=c("header","skip"),data.csv=c(NA,NA),row.names=NULL)
  filename  <-  paste0(readyDir, "/", newStudy, "/dataImportOptions.csv")
  if(!file.exists(filename)){
    write.csv(impo, paste0(readyDir, "/", newStudy, "/dataImportOptions.csv"),row.names=FALSE)
  }
}

a  <-  lapply(newStudies, makeDataImport)

#now edit the dataImportOptions.csv in each new folder accordingly.

#create the proper set of files in each folder
readNewFiles  <-  function(newStudy){
  # Load raw data from newStudy
  #
  # Args: 
  #   newStudy: folder where data is stored
  # 
  # Returns:
  #   dataframe
  
  #import options for data file
  import <-  read.csv(paste0(readyDir,"/",newStudy,"/dataImportOptions.csv"), 
                      h=FALSE, row.names=1, stringsAsFactors=FALSE)  
  
  #brings in the original .csv
  raw     <-  read.csv(paste0(readyDir,"/",newStudy,"/",import['name',]), 
                       h=(import['header',]=="TRUE"), 
                       skip=as.numeric(import['skip',]), 
                       stringsAsFactors=FALSE, strip.white=TRUE, check.names=FALSE)
  raw
}


setUpFiles  <-  function(newStudy){
  print(newStudy)
  
  #creates and writes dataManipulate.R
  cat("creates dataManipulate.R ")
    filename  <-  paste0(readyDir, "/", newStudy, "/dataManipulate.R")
  if(!file.exists(filename)){
    manip     <-  ""
    write(manip, paste0(readyDir,"/",newStudy,"/dataManipulate.R"))
  }  
  
  
  browser()
  #creates dataMatchColumns.csv
  cat("creates dataMatchColumns.csv ")
  filename  <-  paste0(readyDir, "/", newStudy, "/dataMatchColumns.csv")
  if(!file.exists(filename)){
    
    #reads file accounting for dataImportOptions
    newFile   <-  readNewFiles(newStudy)
    
    matchCol  <-  data.frame(var_in=names(newFile), 
                             method=rep(NA,ncol(newFile)), 
                             unit_in=rep(NA,ncol(newFile)), 
                             var_out=rep(NA,ncol(newFile)), 
                             notes=rep(NA,ncol(newFile)), 
                             stringsAsFactors=FALSE)
    write.csv(matchCol, paste0(readyDir,"/",newStudy,"/dataMatchColumns.csv"), row.names=FALSE)
  }
  
  #creates and writes dataNew.csv
  cat("creates dataNew.csv ")
  filename  <-  paste0(readyDir, "/", newStudy, "/dataNew.csv")
  if(!file.exists(filename)){
    datnew  <-  data.frame(lookupVariable="",
                           lookupValue="",
                           newVariable="",
                           newValue="",
                           source="", 
                           stringsAsFactors=FALSE)
    write.csv(datnew, paste0(readyDir,"/",newStudy,"/dataNew.csv"), row.names=FALSE)
  }
  
  #creates and writes studyContact.csv
  cat("creates studyContact.csv ")
  filename  <-  paste0(readyDir, "/", newStudy, "/studyContact.csv")
  if(!file.exists(filename)){
    contact  <-  data.frame(name="",
                            email="",
                            address="",
                            additional.info="",
                            stringsAsFactors=FALSE)
    write.csv(contact, paste0(readyDir,"/",newStudy,"/studyContact.csv"), row.names=FALSE)
  }
  
  #creates and writes studyMetadata.txt
  cat("creates studyMetadata.txt ")
  filename  <-  paste0(readyDir, "/", newStudy, "/studyMetadata.txt")
  if(!file.exists(filename)){
    metadat  <-  ""
    write(metadat, paste0(readyDir,"/",newStudy,"/studyMetadata.txt"))
  }
  
  #creates and writes studyRef.csv
  cat("creates studyRef.csv ")
  filename  <-  paste0(readyDir, "/", newStudy, "/studyMetadata.txt")
  if(!file.exists(filename)){
    sturef  <-  ""
    write.csv(sturef, paste0(readyDir,"/",newStudy,"/studyRef.csv"), row.names=FALSE)
  }
}



a  <-  lapply(newStudies, setUpFiles)
