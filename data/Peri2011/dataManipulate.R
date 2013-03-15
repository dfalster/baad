raw       <-  raw[raw$ref=="peri2011",]
raw$n.lf  <-  (raw$n.lf*raw$m.lf)/raw$a.lf
