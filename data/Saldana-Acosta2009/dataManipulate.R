manipulate <- function(raw) {

  # A number of rows in this dataset had only initial height, no other vars.
  # Delete these.
  raw <- raw[raw[["Final height (cm)"]] > 0,]
  
  
  # Fix zeroes
  ii <- raw[["Leaf biomass (g)"]] == 0
  raw[["Leaf biomass (g)"]][ii] <- NA
  
  ii <- raw[["Stem biomass (g)"]] == 0
  raw[["Stem biomass (g)"]][ii] <- NA
  
  ii <- raw[["Root biomass (g)"]] == 0
  raw[["Root biomass (g)"]][ii] <- NA
  
  
  raw
}
