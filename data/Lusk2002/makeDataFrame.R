#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(6:10)], growingCondition="FW",  vegetation="TempRf", pft="EA", location="Parque Nacional Puyehue, Chile", latitude=-40.65, longitude=-72.18, map=3500, stringsAsFactors=FALSE)
}
