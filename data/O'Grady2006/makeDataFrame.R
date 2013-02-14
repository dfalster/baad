#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Leaf.area  <-  raw$X
  raw$stem       <-  raw$stem+raw$branch
  raw$m.rf       <-  raw$X5.Oct + raw$Oct.15
  raw$m.rc       <-  raw$X15...20 + raw$X20....stump
  data  <-  cbind(dataset=studyName, species="Eucalyptus globulus", grouping=paste("Harvested on ", raw$Harvested, "; Plot = ", raw$plot, "; Treatment = ", raw$treatment, "; seedling = ", raw$seedling, sep=""), raw[,c(5,6,8:11,13,14,16,17,22,23)], latitude=-42.82, longitude=147.51, growingCondition="PM", pft="EA", location="Pittwater plantation, TAS, Australia", map=500, stringsAsFactors=FALSE)
}
