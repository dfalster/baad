manipulate <- function(raw) {
  
  # Four points are massive outliers for stem mass;
  # these are clearly 10 times too low (compared with all other mass components).
  ii <- c(38,39,40,43)
  raw[["STEMWOOD (kg)"]][ii] <- 10*raw[["STEMWOOD (kg)"]][ii]
  
  # And recalculate total above.
  raw[["TOTAL_ABOVE (kg)"]] <- raw[["STEMWOOD (kg)"]] + raw[["STEMBARK (kg)"]] + 
    raw[["BRANCH (kg)"]] + raw[["LEAF (kg)"]]
  
  # m.st was wrongly just bole mass.
  raw$mst <- raw[["TOTAL_ABOVE (kg)"]] - raw[["LEAF (kg)"]]
    
  raw
}

