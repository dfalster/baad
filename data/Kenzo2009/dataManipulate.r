manipulate <- function(raw) {
  raw[["n.lf.per"]]  <-  raw[["n.lf.per"]]/100 # this transforms it from percentage to proportion --> equivalent to kg/kg
  
  raw$grouping <- makeGroups(raw, c("location","contributor","group"))
  
  
  # Three observations are <1.3m but have d.bh recorded. Set to NA
  raw$a.stbh.cm[raw$h.t.m <= 1.3] <- NA
  
  raw
}


