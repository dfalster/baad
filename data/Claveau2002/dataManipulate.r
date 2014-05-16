manipulate <- function(raw) {

 
  # Zero c.d
  raw$c.d[raw$c.d == 0] <- NA

  # same
  raw$h.c[raw$h.t == raw$h.c] <- NA
  
  
raw
}
