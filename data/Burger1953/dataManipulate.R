manipulate <- function(raw) {
    
  raw$grouping <- makeGroups(raw, c("site","altitude"))
  
  raw
}

