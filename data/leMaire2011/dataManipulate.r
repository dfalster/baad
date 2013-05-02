manipulate <- function(raw) {
  raw[["group"]]  <-  paste(raw[["Variable.Unit"]], sep="; ")
  
  raw
}

