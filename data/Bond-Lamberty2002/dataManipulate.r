raw$grouping  <-  paste(raw$Site, raw$HarvestYear, raw$Edaphic, sep="; ")
raw$age       <-  raw$HarvestYear - raw$BurnYear 
raw$stemMass  <-  raw$TotBranch + raw$Stem