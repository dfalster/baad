manipulate <- function(raw) {
  
  raw$h.c <- with(raw, height - hcb)
  
  raw$grouping <- makeGroups(raw, c("site","altitude"))
  
  raw
}

