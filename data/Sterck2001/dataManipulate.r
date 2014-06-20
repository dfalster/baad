manipulate <- function(raw) {
  
  
  # Obvious typo
  raw[["Ht2"]][raw[["Ht2"]] > 50] <- NA
  
  # When height to crown base higher than total plant height
  raw$Ht2[raw$Ht2 > raw$Ht] <- NA
  
  # Geometric mean of two crown widths
  raw$CW <- sqrt(raw$CW1 * raw$CW2)
  
  raw
}

