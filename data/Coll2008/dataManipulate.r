manipulate <- function(raw) {
  
  sladat <- raw[!is.na(raw$individual.leaf.mass.g),c("species","tree","specific.leaf.area.cm2/g")]
  names(sladat)[3] <- "sla"
  sladat <- aggregate(sla ~ species, FUN=mean, data=sladat)
  
  raw  <-  raw[is.na(raw$individual.leaf.mass.g),]
  raw <- merge(raw, sladat, by="species")
  
  raw[["stem.biomass.g"]] <- raw[["branch.biomass.g"]] + raw[["trunk.biomass.g"]]
  raw[["ma.ilf"]] <- 1/raw[["sla"]]
  raw
}

