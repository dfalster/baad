#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw[raw=="No data"] <-  NA
  data   <-  cbind(dataset=studyName, species="Chamaecyparis obtusa", raw[,c(2, 5, 10:17)], vegetation="TempF", growingCondition="PU", stringsAsFactors=FALSE)
}
