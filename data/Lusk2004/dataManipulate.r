manipulate <- function(raw) {
  
  # one zero value
  raw$a.lf[raw$a.lf == 0] <- NA
  
  raw
}

