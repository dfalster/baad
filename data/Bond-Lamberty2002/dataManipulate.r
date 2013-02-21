raw$grouping=paste(raw$Site, raw$HarvestYear, raw$Edaphic, sep="; ")
raw$species=raw$Species
raw$age=raw$HarvestYear-raw$BurnYear 
raw$stemMass=raw$TotBranch+raw$Stem 
raw$longitude=raw$longitude 
raw$latitude=raw$latitude 
