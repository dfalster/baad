manipulate <- function(raw) {
  
  
  # Obvious typo
  raw[["Ht2"]][raw[["Ht2"]] > 50] <- NA
  
  raw
}

