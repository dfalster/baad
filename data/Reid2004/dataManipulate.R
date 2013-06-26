manipulate <- function(raw) {

  raw$grouping <- makeGroups(raw, "sitequal")
  
  # h_c was crownlength, should be height to crown base
  raw$h_c <- with(raw, h_t - h_c)
  
  raw
}
