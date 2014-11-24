manipulate <- function(raw) {
  
  # 9 values have zero leaf mass. The data are correct, as these are decid. trees
  # that had no leaves at time of sampling. For our database, set these to missing values.
  nm <- "Leaf.mass..kg."
  raw[[nm]][raw[[nm]] == 0] <- NA
  
  
  raw
}

