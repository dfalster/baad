manipulate <- function(raw) {
  
  
  # make one h.t zero value missing 
  raw$h.t[raw$h.t == 0] <- NA
  
  raw
}

