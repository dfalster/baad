rm(list=ls())
source('R/Biomass-fun.R')

#Remove existing data files
system("rm data/*/study_contact.csv")

StudyNames  <-  getStudyNames()
alo.sum     <- read.csv("R-working/AllometrySummary - Dataset summary.csv",h=TRUE,stringsAsFactors=FALSE,na.strings=c("NA",""),check.names=FALSE) #allometry summary file
interest    <-  which(names(alo.sum) %in% c("Name of contact", "Email", "Address", "Alternative Contact", "Alternative Email", "Alternative Address"))

make.contact.info  <-  function(studyName){
  y     <-  alo.sum[alo.sum$Dataset==studyName,]
  y     <-  as.character(y[interest])  
  
  if(length(y[y=="character(0)"])==6){
    cont  <-  "missing contact information"
    write.csv(cont, paste0(dir.rawData,"/",studyName,"/study_contact.csv"))
  } else {
    if(length(y)==0){
      cont  <-  "missing contact information"
    }
    if(length(which(!is.na(y)==FALSE))==6){
      cont  <-  "missing contact information"
    } else {
      if(length(which(!is.na(y[4:6])==FALSE))==3) {
        cont  <-  data.frame(name=y[1],email=y[2],address=y[3],stringsAsFactors=FALSE)
      } else { 
        cont  <-  data.frame(name=y[c(1,4)],email=y[c(2,5)],address=y[c(3,6)],stringsAsFactors=FALSE)
        if(is.na(cont[2,1]) & TRUE %in% !is.na(cont[2,])){
          cont$additional.info  <-  paste(cont[2,which(!is.na(cont[2,]))],collapse="; ")
          cont  <-  cont[-2,]
        }
      }
    }
  }
  print(cont)
  write.csv(cont, paste0(dir.rawData,"/",studyName,"/study_contact.csv"))  
}

make.contacts  <-  lapply(StudyNames, make.contact.info)

