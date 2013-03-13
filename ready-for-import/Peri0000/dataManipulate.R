raw       <-  raw[raw$ref=="PeriUnpub"]
raw$n.lf  <-  (raw$n.lf*raw$m.lf)/raw$a.lf
