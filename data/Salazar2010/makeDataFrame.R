#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Stem_biomass  <-  raw$Branch_biomass+raw$Trunk_biomass
  raw$map[raw$Species=="Castanea sativa "]    <-  1590
  raw$map[raw$Species=="Quercus pyrenaica "]  <-  1530
  raw$mat[raw$Species=="Castanea sativa "]    <-  10.8
  raw$mat[raw$Species=="Quercus pyrenaica "]  <-  11.1
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(2:5,7:10)], growingCondition="FW", stringsAsFactors=FALSE)
}
