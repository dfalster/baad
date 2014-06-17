manipulate <- function(raw) {
  
  raw$grouping <- makeGroups(raw, c("Installation","Plot"))
  
  
  raw
}

