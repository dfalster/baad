rm(list=ls())
source('R/import.R')

source('R/formatBib.R')


studyNames<-getStudyNames()

fileName<-"refs.txt"
for(i in 1:length(studyNames)){
  cat(studyNames[[i]], "\n", file= fileName,append= TRUE)
  ref<-readReference(studyNames[[i]])
  cat("\t",ref$reference, "\n", file= fileName, append= TRUE)
  
  bibFile<-data.path(studyNames[[i]], "studyRef.bib")
  if(file.exists(bibFile)){
    bib<- read.bib(bibFile)
   cat("\t", formatBib(bibFile)[[1]], "\n\n", file= fileName, append= TRUE)    
  }
}


