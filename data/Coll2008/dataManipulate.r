manipulate <- function(raw) {
  raw  <-  raw[is.na(raw$individual.leaf.mass.g),]
  raw[["stem.biomass.g"]] <- raw[["branch.biomass.g"]] + raw[["trunk.biomass.g"]]
  raw[["ma.ilf"]] <- 1/raw[["specific.leaf.area.cm2/g"]]
  raw
}

