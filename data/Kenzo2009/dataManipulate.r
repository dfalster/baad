manipulate <- function(raw) {
  raw[["n.lf.per"]]  <-  raw[["n.lf.per"]]/100 # this transforms it from percentage to proportion --> equivalent to kg/kg
  
  raw$grouping <- makeGroups(raw, c("location","contributor","group"))
    
  raw
}


