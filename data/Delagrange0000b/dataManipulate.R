manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("Site", "Seedbed"))
  raw
}

