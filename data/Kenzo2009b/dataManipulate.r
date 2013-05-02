manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("location", "contributor"))
  
  raw
}

