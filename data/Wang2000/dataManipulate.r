manipulate <- function(raw) {
  raw[["m.rc"]]       <-  raw[["Lrg. Root"]] + raw[["Med. Root"]]
  raw[["Stem Wood"]]  <-  raw[["Stem Wood"]] + raw[["Stem Bark"]]
  
  raw
}

