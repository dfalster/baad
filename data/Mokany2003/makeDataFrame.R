#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(7:22)], reference=paste(raw$Name, raw$Year, raw$Title, raw$Symbol, sep=""), stringsAsFactors=FALSE)
}
