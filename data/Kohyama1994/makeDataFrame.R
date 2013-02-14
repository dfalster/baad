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
  raw$SpecCode[raw$SpecCode=='Ci']  <-  "Eurya japonica"		
  raw$SpecCode[raw$SpecCode=='Sb']  <-  "??1"		
  raw$SpecCode[raw$SpecCode=='Daph.']   <-  "??2"		
  raw$SpecCode[raw$SpecCode=='Ardis.']  <-  "??3"		
  raw$SpecCode[raw$SpecCode=='Sarca.']  <-  "??4"		
  data   <-  cbind(dataset=studyName, species=raw$SpecCode, raw[,c(3:5, 10:ncol(raw))], latitude=30, longitude=130, growingCondition="FW", vegetation="TempRf", location="Yakushima Island, Kyushu, Japan", reference="Kohyama T, Grubb PJ (1994) Below- and above-ground allometries of shade-tolerant seedlings in a Japanese warm-temperate rain forest. Functional Ecology 8:229–236.", stringsAsFactors=FALSE)
}
