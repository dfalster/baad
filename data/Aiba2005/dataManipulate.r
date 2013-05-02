manipulate <- function(raw) {
  raw$species  <-  paste(raw[["Genus"]], raw[["Species"]])
  
  
  raw
}

