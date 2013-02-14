#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$m.rc       <-  raw$Lrg..Root+raw$Med..Root
  raw$Stem.Wood  <-  raw$Stem.Wood + raw$Stem.Bark
  
  raw$pft[raw$species=="Abies lasiocarpa"]   <-  "EG" 
  raw$pft[raw$species=="Betula papyrifera"]  <-  "DA"
  
  data       <-  cbind(dataset=studyName, species=raw$species, raw[,c(3:11,14:17)], growingCondition="FW", vegetation="BorF", location="24 km east of Prince George, British Columbia, CA", map=628.3, stringsAsFactors=FALSE)
}
