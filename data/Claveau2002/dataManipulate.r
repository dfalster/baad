manipulate <- function(raw) {

 
  # Zero c.d
  raw$c.d[raw$c.d == 0] <- NA

raw
}
