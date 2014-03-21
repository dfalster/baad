manipulate <- function(raw) {
  
  
  raw$grouping  <- makeGroups(raw, "Variable")
  
  raw
}

