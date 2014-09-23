manipulate <- function(raw) {
  
  # Geometric mean of two diameter measurements
  raw[["d.cr"]] <- sqrt(raw[["d.cr"]] * raw[["d.cr2"]])
  
  # Set zero and negative crown depth to NA
  ii <- which(raw$c.d <= 0)
  raw$c.d[ii] <- NA
  
  # When crown depth > h.t, set to h.t
  ii <- which(raw$c.d > raw$h.t)
  raw$c.d[ii] <- raw$h.t[ii]
  
  raw
}
