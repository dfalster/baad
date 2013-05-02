manipulate <- function(raw) {
  raw$grouping             <- makeGroups(raw, c("Group", "Last perturbation"))
  
  
  raw
}

