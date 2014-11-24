manipulate <- function(raw) {
  
  raw$grouping <- makeGroups(raw, c("CO2", "H2O"))
  
  raw
}

