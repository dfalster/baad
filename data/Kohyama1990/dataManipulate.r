manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("Year"))
  raw
}

