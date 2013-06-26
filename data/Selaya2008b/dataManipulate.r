manipulate <- function(raw) {
  raw        <-  raw[raw[["reference"]]=="Selaya et al. (2008) Journal of Ecology 96: 1211-1221; Selaya & Anten (2010) Ecology 91:1102-1113",]
  raw[["light"]]  <-  raw[["light"]]/55*100
  raw$n.lf  <-  raw$n.lf*raw$a.lf/raw$m.lf
  
  raw
}

