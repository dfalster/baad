#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Sp[raw$Sp=="VA"]  <-  "Vouacapoua americana Aubl."
  raw$Sp[raw$Sp=="DG"]  <-  "Dicorynia guianensis Amshoff."
  data   <-  cbind(dataset=studyName, species=raw$Sp, raw[,c(4:8,10:12,15)], growingCondition="FW", vegetation="TropRF", location="les Nouragues Biological Field Station, French Guiana", latitude=4.08, longitude=-52.66, map=3000, stringsAsFactors=FALSE)
}
