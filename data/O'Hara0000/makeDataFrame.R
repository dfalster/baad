#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species="Sequoiadendron giganteum", raw[,c(2:4, 6:ncol(raw))], stringsAsFactors=FALSE)
}
