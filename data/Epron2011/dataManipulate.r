manipulate <- function(raw) {
  
  # 'Better to remove fine root biomass from the database'
  raw$m.rf <- NULL
  
  # location
  raw$location <- paste(raw$location, raw$location2)
  
  

  raw
}


