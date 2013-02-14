#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$stem.dry.mass..g. <-  raw$stem.dry.mass..g.+ raw$branch.dry.mass..g.
  data       <-  cbind(dataset=studyName, species=raw$Species, raw[,c(4:8,10:13)], growingCondition="FW", vegetation="TropRF", location=raw$site, pft="DA", latitude=4.12, longitude=114, map=3200, stringsAsFactors=FALSE)
}
