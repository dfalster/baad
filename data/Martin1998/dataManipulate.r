manipulate <- function(raw) {
  raw[["N.lf"]]      <-  (raw[["N.lf"]]/100) #transforms from percentage to proportion, equivalent to kg.kg
  raw$grouping  <-  makeGroups(raw, c("Filter"))
  
  # age of 0 seems unlikely :)
  raw$age[raw$age == 0] <- NA
  
  raw
}

