manipulate <- function(raw) {
  raw[["Leaf mass per area :LMA*100 g cm-2"]]  <-  raw[["Leaf mass per area :LMA*100 g cm-2"]]/100
  raw[["N (%) in leaves"]]  <-  raw[["N (%) in leaves"]]/100
  raw
}
