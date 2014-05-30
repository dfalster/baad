manipulate <- function(raw) {
  raw$Species  <-  paste(raw[["Genus"]], raw[["Species"]])
  
  
  raw
}

