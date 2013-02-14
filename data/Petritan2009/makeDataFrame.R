#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(2:ncol(raw))], latitude=51.57944, longitude=10.03639, map=780, mat=7.8, growingCondition="FW", vegetation="TempF", pft="EA / DA", stringsAsFactors=FALSE)
}
