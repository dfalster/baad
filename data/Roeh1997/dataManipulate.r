manipulate <- function(raw) {
  
  # h_c was crownlength, should be height to crown base
  raw$h.c <- with(raw, h.t - h.c)
  
  
  raw
}

