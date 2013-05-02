manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("Soil","H2O", "P"))
  
  raw
}

