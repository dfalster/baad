manipulate <- function(raw) {

  raw$grouping <- paste("Site-quality=", raw$sitequal)
  
  raw
}
