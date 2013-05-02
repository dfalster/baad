manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("wood.type", "collection.site", "sample"))
  
  raw
}

