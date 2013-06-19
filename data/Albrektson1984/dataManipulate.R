manipulate <- function(raw) {
  
  
  raw$grouping <- makeGroups(raw, "fertilized")
  
  # remove crown surface area, was calculated from crown width and length
  raw$a.cs <- NULL
  
  raw
}

