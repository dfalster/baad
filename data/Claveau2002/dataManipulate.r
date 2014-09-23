manipulate <- function(raw) {

 
  # Zero c.d
  raw$c.d[raw$c.d == 0] <- NA

  # When crown depth > height, set to height
  ii <- which(raw$c.d > raw$h.t)
  raw$c.d[ii] <- raw$h.t[ii]
  raw$h.c[ii] <- 0
  
  
raw
}
