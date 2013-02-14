#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data       <-  cbind(dataset=studyName, species="Pinus sylvestris var. mongolica", raw[,c(2:ncol(raw))], growingCondition="PM", location="Liaoning Sand Stabilization and Afforestation Institute in Zhanggutai, China", pft="EG", latitude=42.72, longitude=122.3667, map=505.9, mat=6, stringsAsFactors=FALSE)
}
