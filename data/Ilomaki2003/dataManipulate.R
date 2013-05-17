manipulate <- function(raw) {
  
  raw$grouping <- paste("Stand=", raw$stand)
  
  raw
}

