manipulate <- function(raw) {
  
  raw$grouping <- paste("fertilized=", raw$fertilized)
  
  raw
}

