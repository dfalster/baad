#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, raw[,c(1:7,9)], growingCondition="PU", vegetation="TempF",   stringsAsFactors=FALSE)
}
