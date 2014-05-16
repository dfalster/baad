manipulate <- function(raw) {

  raw$grouping <- makeGroups(raw, "grouping")
  
  # Mistake in original processing
  raw$h.c <- raw$h.t - raw$h.c
  raw$c.d <- raw$h.t - raw$h.c
  
  
  raw
}
