#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Stem_biomass  <-  raw$Branch_biomass+raw$Trunk_biomass
  raw$pft[raw$Species=="Fagus sylvatica"]    <-  "DA"
  raw$pft[raw$Species=="Pinus sylvestris"]   <-  "EG"
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(2:5,7,10:11)], growingCondition="FW", location="Sierra de la Demanda, Spain", vegetation="TempF", latitude=42.33, longitude=4.16, mat=12.4, map=895, stringsAsFactors=FALSE)
}
