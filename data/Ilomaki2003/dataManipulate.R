manipulate <- function(raw) {
  
  raw$grouping <- makeGroups(raw, "stand")
  
  raw
}

