#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$status[raw$crown.class=="i"]   <-  1
  raw$status[raw$crown.class=="s"]   <-  0
  raw$status[raw$crown.class=="d"]   <-  3
  raw$status[raw$crown.class=="cd"]  <-  2  
  data   <-  cbind(dataset=studyName, species="Sequoia sempervirens", raw[,c(2:3, 6, 7, 13:16)], growingCondition="FW",  pft="EA", vegetation="TempF",  map=1300, latitude=39.37278, longitude=-123.6556, location="Jackson Demonstration State Forest, California, USA", stringsAsFactors=FALSE)
}
