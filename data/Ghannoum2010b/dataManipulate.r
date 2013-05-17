manipulate <- function(raw) {
  
  raw$grouping <- paste("Temp-CO2=", raw$Temp, raw$CO2)
  
  raw
}

