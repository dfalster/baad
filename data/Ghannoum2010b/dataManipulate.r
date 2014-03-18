manipulate <- function(raw) {
  
  raw$grouping <- makeGroups(raw, c("CO2", "Temp"))
  
  # Fix species
  raw$Species <- "Eucalyptus saligna"
  
  raw
}

