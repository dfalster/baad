manipulate <- function(raw) {
  raw       <-  raw[raw$ref=="peri2008",]
  
  # Fix zeroes
  raw$m.st[raw$m.st == 0] <- NA
  
  raw
}

