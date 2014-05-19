manipulate <- function(raw) {
  
  raw$grouping  <-  makeGroups(raw, c("Site","HarvestYear","Edaphic"))
  raw$age       <-  raw[["HarvestYear"]] - raw[["BurnYear"]] 
  raw[["stemMass"]]  <-  raw[["TotBranch"]] + raw[["Stem"]]
  
  # zero root mass
  raw$Root[raw$Root == 0] <- NA
  
  raw
}

