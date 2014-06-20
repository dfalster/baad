manipulate <- function(raw) {
  
  # Geometric mean of two diameter measurements
  raw[["d.cr"]] <- sqrt(raw[["d.cr"]] * raw[["d.cr2"]])
  
  # Set zero and negative crown depth to NA
  raw$c.d[raw$c.d <= 0] <- NA
  
  raw
}
