manipulate <- function(raw) {
  
  raw$grouping  <-  makeGroups(raw, c("Site","HarvestYear","Edaphic"))
  raw[["stemMass"]]  <-  raw[["TotBranch"]] + raw[["Stem"]]
  
  raw
}

