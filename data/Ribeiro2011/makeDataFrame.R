#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  names(raw)[3]         <-  "family"
  names(raw)[15:17]     <-  c("location","map", "mat")
  names(raw)[13]        <-  "vegetation"
  names(raw)[14]        <-  "growingCondition"  
  raw$vegetation        <-  "TropSF (Savannah like)"
  raw$growingCondition  <-  "FW"
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(3:6,9,13:17)], latitude=-18.66, longitude=-44, stringsAsFactors=FALSE)
}
