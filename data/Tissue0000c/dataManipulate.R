manipulate <- function(raw) {
  
  raw$grouping <- makeGroups(raw, c("CO2", "Temp")) 
  
  raw$Nmass <- raw$Narea / raw$LMA
  
  raw
}

