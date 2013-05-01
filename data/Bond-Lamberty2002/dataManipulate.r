
raw$grouping  <-  makeGroups(raw, c("Site","HarvestYear","Edaphic"))
raw$age       <-  raw[["HarvestYear"]] - raw[["BurnYear"]] 
raw[["stemMass"]]  <-  raw[["TotBranch"]] + raw[["Stem"]]

