manipulate <- function(raw) {
  raw[["Stem_biomass"]]  <-  raw[["Branch_biomass"]] + raw[["Trunk_biomass"]]
  
  raw
}

