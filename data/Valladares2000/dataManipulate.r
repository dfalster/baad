manipulate <- function(raw) {
  raw[["species"]]  <-  gsub("P.", "Psychotria", raw[["species"]])
  
  raw
}

