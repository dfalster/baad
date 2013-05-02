manipulate <- function(raw) {
  raw       <-  raw[raw$ref=="periUnpub",]
  raw$n.lf  <-  (raw$n.lf*raw$m.lf)/raw$a.lf
  raw
}

