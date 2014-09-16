manipulate <- function(raw) {
  raw[["Stem_biomass"]]  <-  raw[["Branch_biomass"]] + raw[["Trunk_biomass"]]
  
  
  # Couple glitches in total aboveground biomass, recalculate
  raw[["Total biomass"]] <- raw[["Stem_biomass"]] + raw[["Leaf_biomass"]]
  
  raw
}

