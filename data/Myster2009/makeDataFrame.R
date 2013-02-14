#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, raw[,c(2:6)], latitude=36.78333, longitude=-96.41667, map=820, vegetation="TempF", growingCondition="PM", stringsAsFactors=FALSE)
}
