
for(studyName in studyNames){
  cat(studyName, "\n")
  ref<-read.csv(paste0(dir.rawData,"/",studyName,"/studyContact.csv"), h= TRUE, stringsAsFactors=FALSE, strip.white = TRUE)
  if(is.null(ref$additional.info))
    ref$additional.info =""
  write.csv(ref, paste0(dir.rawData,"/",studyName,"/studyContact.csv"), row.names=FALSE)
}

