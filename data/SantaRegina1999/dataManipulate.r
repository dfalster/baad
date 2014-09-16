manipulate <- function(raw) {
  raw[["Stem_biomass"]]  <-  raw[["Branch_biomass"]] + raw[["Trunk_biomass"]]
  
  
  # One glitch in total biomass, should be 151 not 161
  # (check sum of leaf,branch,trunk with total biomass)
  ii <- raw[["Total biomass"]] == 161
  raw[["Total biomass"]][ii] <- 151
  
  raw
}

