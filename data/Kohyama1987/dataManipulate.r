manipulate <- function(raw) {
  raw[["leaf.mass"]]  <-  raw[["Wtl.g"]] + raw[["Wbl.g"]]
  raw[["m.st"]]       <-  raw[["Wts.g"]] + raw[["Wbs.g"]]
  
  
  raw
}

