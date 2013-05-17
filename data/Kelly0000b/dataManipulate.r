manipulate <- function(raw) {
  
  raw$grouping <- paste("CO2-Water=", raw$CO2, raw$H2O)
  
  raw
}

