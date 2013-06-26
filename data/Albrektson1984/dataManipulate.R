manipulate <- function(raw) {
  
  
  raw$grouping <- makeGroups(raw, "fertilized")
  
  # remove crown surface area, was calculated from crown width and length
  raw$a.cs <- NULL
  
  # h.c was defined as crown length, should be height to base of crown
  raw$h.c <- with(raw, h.t - h.c)
  
  raw
}

