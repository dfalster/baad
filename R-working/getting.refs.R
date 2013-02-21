rm(list=ls())
source('R/Biomass-fun.R')

dir.output  <-  "output/data"
#Remove existing data files
system("rm data/*/study_ref.csv")

StudyNames  <-  getStudyNames()

get.ref  <-  function(studyName) {
  dat         <-  read.csv(paste0(dir.output,"/",studyName,".csv"),h=TRUE,stringsAsFactors=FALSE,na.strings=c("NA",""))
  names(dat)  <-  lownames(dat)
  cat(studyName, " ")
  ref.col     <-  grep("ref", names(dat)) #column that contains reference information
  if(length(ref.col) > 0){
    fin.ref     <-  data.frame(reference=unique(dat[,ref.col])) #makes a data frame in case there are more than one refs in ref.col
    write.csv(fin.ref, paste0(dir.rawData,"/",studyName,"/study_ref.csv"))
  } else {
    fin.ref     <-  "this study does not contain reference information yet"
    write.csv(fin.ref, paste0(dir.rawData,"/",studyName,"/study_ref.csv"))
  }
}  

getting.refs  <-  lapply(StudyNames, get.ref)