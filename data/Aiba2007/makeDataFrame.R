#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$total.stem.mass..g.  <-  raw$branch.mass...stem.mass..g.
  data       <-  cbind(dataset=studyName, species=paste(raw$genus, raw$species), raw[,c(3:5,7:13)], growingCondition="FW", vegetation="TropRF", pft="EA", location="Lambir Hills National Park, Sarawak, Malaysia", latitude=4.03, longitude=113.83, map=2700, mat=26, stringsAsFactors=FALSE)
}
