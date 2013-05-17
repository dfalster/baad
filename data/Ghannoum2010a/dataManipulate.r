manipulate <- function(raw) {
  
  raw$grouping <- paste("CO2-Temp-Water=", raw$CO2, raw$Temp, raw$Water)
  
  raw
}

