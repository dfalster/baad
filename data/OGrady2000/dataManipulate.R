manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("SITE"))
  
  raw
}

