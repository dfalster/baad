#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(6:ncol(raw))], growingCondition="GH",  pft="EA", location="New Zealand", stringsAsFactors=FALSE)
}
