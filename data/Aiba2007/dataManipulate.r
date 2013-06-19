manipulate <- function(raw) {
  raw[["species"]]  <-  paste(raw[["genus"]], raw[["species"]])
  
  raw$crownlength <- raw[,"height (cm)"] - raw[,"crown height (cm)"]
  
  # this gives one negative value, set to NA
  raw$crownlength[raw$crownlength < 0] <- NA
  
  raw
}

