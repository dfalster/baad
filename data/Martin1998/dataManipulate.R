manipulate <- function(raw) {
  raw[["N.lf"]]      <-  (raw[["N.lf"]]/100) #transforms from percentage to proportion, equivalent to kg.kg
  raw$grouping  <-  makeGroups(raw, c("Filter"))
  
  # age of 0 seems unlikely :)
  raw$age[raw$age == 0] <- NA
  
  # Zero N% fix
  raw$N.sa[raw$N.sa == 0] <- NA
  raw$N.ht[raw$N.ht == 0] <- NA
  raw$N.ba[raw$N.ba == 0] <- NA
  
  # One wood density clearly wrong (other values for this species are ca. 500.)
  raw$RHO[raw$RHO > 1500] <- NA
  
  raw
}

