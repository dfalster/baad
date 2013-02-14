#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$a.babh <-  raw$a.st - raw$a.st.1
  names(raw)[names(raw)=="group"]  <-  "grouping"
  raw$reference  <-  "Epron D, Laclau J-P, Almeida JCR, Goncalves JLM, Ponton S, Sette Jr CR, Delgado-Rojas JS, Bouillet J-P, Nouvellon Y (2012) Do changes in carbon allocation account for the growth response to potassium and sodium applications in tropical Eucalyptus plantations? Tree Physiology 32:667–679; Almeida JCR, Laclau J-P, Goncalves JLM, Ranger J, Saint-Andre L (2010) A positive growth response to NaCl applications in Eucalyptus plantations established on K-deficient soils. Forest Ecology and Management 259:1786–1795; Laclau J-P unpublished."
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Variable, raw$contributor, raw$Nutrition, sep="; "), raw[,c(3, 6:10, 12:19, 22:ncol(raw))], stringsAsFactors=FALSE)
}
