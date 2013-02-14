#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data     <-  cbind(dataset=studyName, species="Betula papyrifera Marsh", raw[,c(2:8)], growingCondition="FW", vegetation="BorF", pft="DA", location="British Columbia, CA", map=668, stringsAsFactors=FALSE)
}
