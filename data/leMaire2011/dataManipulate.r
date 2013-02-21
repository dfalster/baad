names(raw)[names(raw)=="map.mm"]  <-  "map"
raw$species=raw$species
raw$grouping=paste(raw$Variable.Unit, sep="; ")