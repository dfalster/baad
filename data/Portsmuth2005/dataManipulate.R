manipulate <- function(raw) {
  raw[["III year needles N%"]]  <-  raw[["III year needles N%"]]/100
  raw[["coarse root N%"]]       <-  raw[["coarse root N%"]]/100
  raw
}
