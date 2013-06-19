manipulate <- function(raw) {
  
  raw$grouping <- makeGroups(raw, "site")
  
  raw
}

