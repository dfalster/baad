#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data  <-  cbind(species=paste(raw$Genus, raw$Species), raw[,3:12], stringsAsFactors=FALSE)
}
