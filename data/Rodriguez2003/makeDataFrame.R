#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Bark_Stemwood  <-  raw$Bark + raw$Stemwood
  raw$Crown_class[raw$Crown_class==1]  <-  "intermediate"
  raw$Crown_class[raw$Crown_class==1]  <-  "codominant"
  raw$Crown_class[raw$Crown_class==1]  <-  "dominant"
  data   <-  cbind(dataset=studyName, species="Pinus radiata", grouping=paste("Treatment", raw$Treatment, raw$Crown_class, sep="; "), raw[,c(4:8,10,12:ncol(raw))], latitude=-34.2, longitude=-72.93, growingCondition="PM", vegetation="TempF", pft="EG", map=700, mat=13.64, stringsAsFactors=FALSE)
}
