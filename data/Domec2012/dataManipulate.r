manipulate <- function(raw) {
  raw[["Leaf nitrogen"]]  <-  raw[["Leaf nitrogen"]]*raw[["Total leaf area"]]/raw[["Total leaf mass"]]
  raw
}

