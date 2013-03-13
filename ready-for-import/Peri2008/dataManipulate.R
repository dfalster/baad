raw       <-  raw[raw$ref=="Peri2008"]
raw$n.lf  <-  (raw$n.lf*raw$m.lf)/raw$a.lf
