#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$species[raw$species=="AR"]  <-  "Acer rubrum"
  raw$species[raw$species=="AS"]  <-  "Acer saccharum"
  raw$species[raw$species=="BA"]  <-  "Betula alleghaniensis"
  raw$species[raw$species=="FA"]  <-  "Fraxinus americana"
  raw$species[raw$species=="QR"]  <-  "Quercus rubra"
  raw$species[raw$species=="UA"]  <-  "Ulmus americana"
  raw$species[raw$species=="BP"]  <-  "Betula papyrifera"
  names(raw)[names(raw) == "Plant.functional.type"]    <-  "pft"
  names(raw)[names(raw) == "Growing.condition"]        <-  "growingCondition"
  raw$reference                                        <-  "Baltzer JL, Thomas SC (2007) Physiological and morphological correlates of whole-plant light compensation point in temperate deciduous tree seedlings. Oecologia 153:209–223."
  data   <-  cbind(dataset=studyName, species=raw$species, raw[,c(4:16,18,21:24)], latitude=43.66146, longitude=-79.40006, stringsAsFactors=FALSE)
}
