manipulate <- function(raw) {
  
  raw$grouping <- paste("Temp-CO2-Genotype=",raw$Temp,raw$CO2,raw$Genotype)
  
  raw
}

