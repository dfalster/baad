#Define a  function for that constructs dataframe for this study
#TODO: not finsihed?
makeDataFrame<-function(raw, studyName){
  names(raw)[2:3]  <-  c("Indonesian name", "Species")
  raw$Species[raw$Species=='Landom']  <-  "Lansium domesticum"
  raw$Species[raw$Species=='Durzib']  <-  "Durio zibethinus"
  raw$Species[raw$Species=='Hevbra']  <-  "Hevea brasiliensis"
  raw$Species[raw$Species=='Alssch']  <-  "Alstonia scholaris"
  raw$Species[raw$Species=='Schwal']  <-  "Schima wallichii"
  raw$Species[raw$Species=='Fagfra']  <-  "Fagraea fragrans"
  raw$Species[raw$Species=='Shoste']  <-  "Shorea stenoptera"
  raw$Species[raw$Species=='Pitjir']  <-  "Archidendron jiringa"
  raw$Species[raw$Species=='Acaman']  <-  "Acacia mangium"
  raw$Species[raw$Species=='Albfal']  <-  "Albizia falcataria"
  
  for(j in 1:nrow(raw)){
    if(raw$Species[j]=="Acacia mangium" | raw$Species[j]=="Albizia falcataria"){
      raw$sp_measure_envir[j]  <-  "monocultural stands"
    } else {
      raw$sp_measure_envir[j]  <-  "mixed agroforest plots"  			}			
  }
  data   <-  cbind(dataset=studyName, species=raw$Species, grouping=paste(paste("Isolation_", raw$Isolated, sep=""), paste("Area Density_", raw$Dense, sep=""), raw$sp_measure_envir, sep="; "), raw[,c(1, 5, 8, 10:11, 17:18)], growingCondition="FW", vegetation="TropRF", reference="Harja D, Vincent G, Mulia R, van Noordwijk M (2012) Tree shape plasticity in relation to crown exposure. Trees 26(4):1275–1285.", stringsAsFactors=FALSE)
}
