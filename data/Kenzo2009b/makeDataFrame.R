#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$location, raw$contributor, sep="; "), raw[,c(2, 4:ncol(raw))], stringsAsFactors=FALSE)
}
