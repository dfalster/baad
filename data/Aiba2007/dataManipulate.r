manipulate <- function(raw) {
  raw[["species"]]  <-  paste(raw[["genus"]], raw[["species"]])
  
  
  # Set height to crown base > plant height to NA
  i <- raw[["crown height (cm)"]] > raw[["height (cm)"]]
  rawraw[["crown height (cm)"]][i] <- NA

  raw
}

