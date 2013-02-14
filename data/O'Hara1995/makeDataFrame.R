#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=raw$site, raw[,c(1:3, 5:7, 9)], vegetation="TempF", growingCondition="FW", stringsAsFactors=FALSE)
}
