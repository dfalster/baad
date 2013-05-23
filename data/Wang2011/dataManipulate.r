manipulate <- function(raw) {
  
  # Data for Age=1 clearly unusable: all leaf mass is exactly 0.1g
  i <- match("Total leaf dry mass (g)", names(raw))
  raw <- raw[raw[,i] > 0.01,]
  
  raw
}

