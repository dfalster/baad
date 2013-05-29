manipulate <- function(raw) {
  raw        <-  raw[raw[["reference"]]=="Selaya & Anten (2008) Functional Ecology 22: 30-39",]
  raw[["light"]]  <-  raw[["light"]]/55*100
  raw$n.lf  <-  raw$n.lf*raw$a.lf/raw$m.lf
  raw
}

