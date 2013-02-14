#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data     <-  cbind(dataset=studyName, species="Populus tremuloides Michx.", raw[,c(2:8)], growingCondition="FW", vegetation="BorF", pft="DA", location="Dawson Creek, Forest District of northeastern British Columbia, CA", map=450, stringsAsFactors=FALSE)
}
