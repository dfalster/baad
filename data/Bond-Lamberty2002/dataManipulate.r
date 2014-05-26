manipulate <- function(raw) {
  
  raw$grouping  <-  makeGroups(raw, c("Site","HarvestYear","Edaphic"))
  raw$age       <-  raw[["HarvestYear"]] - raw[["BurnYear"]] 
  raw[["stemMass"]]  <-  raw[["TotBranch"]] + raw[["Stem"]]
  
  # three observations are h.t < 1.37, and d.bh is recorded (even though dbh is measured at 1.37 in this case)
  # set to NA
  raw$DBH[raw$Height < 137] <- NA
  
  # zero root mass
  raw$Root[raw$Root == 0] <- NA
  
  raw
}

