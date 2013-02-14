#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, raw[,c(5:ncol(raw))], stringsAsFactors=FALSE)
}
