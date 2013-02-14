#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species="????????", raw[,c(4:10)], stringsAsFactors=FALSE)
}
