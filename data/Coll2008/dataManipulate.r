manipulate <- function(raw) {
  raw  <-  raw[is.na(raw$individual.leaf.mass.g),]
  raw[["stem.biomass.g"]] <- raw[["branch.biomass.g"]] + raw[["trunk.biomass.g"]]
  raw
}

