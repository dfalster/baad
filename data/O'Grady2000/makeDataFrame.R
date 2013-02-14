#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$SPECIES[raw$SPECIES=="E.tet."]    <-  "Eucalyptus tetrodonta"
  raw$SPECIES[raw$SPECIES=="E.min."]    <-  "Eucalyptus miniata"
  raw$SPECIES[raw$SPECIES=="T.ferd."]   <-  "Terminalia ferdinandiana"
  raw$SPECIES[raw$SPECIES=="E.min"]     <-  "Eucalyptus miniata"
  raw$SPECIES[raw$SPECIES=="E.chlor."]  <-  "Erythrophloem chlorostachys"
  raw$SPECIES[raw$SPECIES=="E.clav."]   <-  "Eucalyptus clavigera"
  data  <-  cbind(dataset=studyName, species=raw$SPECIES, grouping=paste("Site = ", raw$SITE, sep=""), raw[,c(3,9,11,12,15)], latitude=-12.5, longitude=130.75, growingCondition="FW", pft="EA", vegetation="Sav", location="Howard Springs, NT, Australia", map=1700, stringsAsFactors=FALSE)
}
