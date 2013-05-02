manipulate <- function(raw) {
  raw       <-  raw[raw$ref=="peri2008",]
  raw$n.lf  <-  (raw$n.lf*raw$m.lf)/raw$a.lf
  raw
}

