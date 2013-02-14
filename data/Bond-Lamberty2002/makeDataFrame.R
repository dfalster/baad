#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Species[raw$Species=='A']   <-  "Populus tremuloides"
  raw$Species[raw$Species=='BI']  <-  "Betula papyrifera"
  raw$Species[raw$Species=='BS']  <-  "Picea mariana"
  raw$Species[raw$Species=='JP']  <-  "Pinus banksiana"
  raw$Species[raw$Species=='T']   <-  "Larix laricina"
  raw$Species[raw$Species=='W']   <-  "Salix spp"
  data   <-  cbind(dataset=studyName, grouping=paste(raw$Site, raw$HarvestYear, raw$Edaphic, sep="; "), species=raw$Species, age=raw$HarvestYear-raw$BurnYear, stemMass=raw$TotBranch+raw$Stem, raw[,c("Height", "D0", "DBH", "TotFol", "Sapwood", "Root")], longitude=raw$longitude, latitude=raw$latitude, growingCondition="FW", vegetation="BorF", location="Near Thompson and Leaf Rapids, Manitoba, Canada", reference="Bond-Lamberty B, Wang C, Gower ST (2002) Aboveground and belowground biomass and sapwood area allometric equations for six boreal tree species of northern Manitoba. Canadian Journal of Forest Research 32:1441–1450.", stringsAsFactors=FALSE)

}
