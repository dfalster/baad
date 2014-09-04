manipulate <- function(raw) {

  # A number of rows in this dataset had only initial height, no other vars.
  # Delete these.
  raw <- raw[raw[["Final height (cm)"]] > 0,]
  
  
  # Fix zeroes
  ii <- raw[["Leaf biomass (g)"]] == 0
  raw[["Leaf biomass (g)"]][ii] <- NA
  
  ii <- raw[["leafbiomass_fixed"]] == 0
  raw[["leafbiomass_fixed"]][ii] <- NA
  
  # Data flagged as problematic, but no errors found.
  # Set leaf mass to NA - there must be a problem here.
  ii <- raw[["leafmassproblem"]] == "y"
  raw[["leafbiomass_fixed"]][ii] <- NA
  
  ii <- raw[["Stem biomass (g)"]] == 0
  raw[["Stem biomass (g)"]][ii] <- NA
  
  ii <- raw[["Root biomass (g)"]] == 0
  raw[["Root biomass (g)"]][ii] <- NA
  
  ii <- raw[["SLA (cm2 g-1)"]] == 0
  raw[["SLA (cm2 g-1)"]][ii] <- NA
  
  raw
}
