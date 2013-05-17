manipulate <- function(raw) {
  raw[["N.lf"]]      <-  (raw[["N.lf"]]/100)*raw[["LMA"]] #transforms from percentage to the units of LMA so it can later be converted into kg/m2
  raw$grouping  <-  makeGroups(raw, c("Filter"))
  
  raw
}

