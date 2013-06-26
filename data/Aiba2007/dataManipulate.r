manipulate <- function(raw) {
  raw[["species"]]  <-  paste(raw[["genus"]], raw[["species"]])
    
  raw
}

