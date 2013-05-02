manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("Tree_no","growth_form"))
  
  raw
}

