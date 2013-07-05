manipulate <- function(raw) {
  raw[["group"]]  <-  paste(raw[["Variable"]], sep="; ")
  
  raw
}

