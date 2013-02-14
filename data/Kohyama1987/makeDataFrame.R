#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$SpecCode[raw$SpecCode=='Cs']  <-  "Camellia sasanqua"
  raw$SpecCode[raw$SpecCode=='Cj']  <-  "Camellia japonia"
  raw$SpecCode[raw$SpecCode=='Na']  <-  "Neolitsea aciculata"
  raw$SpecCode[raw$SpecCode=='Sg']  <-  "Symplocos glauca"
  raw$SpecCode[raw$SpecCode=='Pn']  <-  "Podocarpus nagi"
  raw$SpecCode[raw$SpecCode=='Ia']  <-  "Illicium anisatsum"
  raw$SpecCode[raw$SpecCode=='Dr']  <-  "Distylium racemosum"
  raw$SpecCode[raw$SpecCode=='Ms']  <-  "Myrsine seguinii"
  raw$SpecCode[raw$SpecCode=='St']  <-  "Symplocos tanakae"
  raw$SpecCode[raw$SpecCode=='Sp']  <-  "Symplocos purnifolia"
  raw$SpecCode[raw$SpecCode=='Rt']  <-  "Rhododendron tashiroi"
  raw$SpecCode[raw$SpecCode=='La']  <-  "Litsea acuminata"
  raw$SpecCode[raw$SpecCode=='Cl']  <-  "Cleyera japonica"
  raw$SpecCode[raw$SpecCode=='Ej']  <-  "Eurya japonica"  	
  raw$leaf.mass  <-  raw$Wtl.g + raw$Wbl.g
  raw$m.st       <-  raw$Wts.g + raw$Wbs.g
  data   <-  cbind(dataset=studyName, species=raw$SpecCode, raw[,c(5:8, 14:ncol(raw))], latitude=30.31667, longitude=130.4333, location="Ohkou River, Yakushima Island, Kyushu, Japan", reference="Kohyama T (1987) Significance of architecture and allometry in saplings. Functional Ecology 1:399–404.", growingCondition="FW", vegetation="TempRf", stringsAsFactors=FALSE)
}
