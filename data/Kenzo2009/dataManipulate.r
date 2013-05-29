manipulate <- function(raw) {
  raw[["n.lf.per"]]  <-  (raw[["n.lf.per"]]/100) * raw[["lf.ma.g.m2"]] # this transforms it from percentage (/unit mass) to /unit area --> final unit g/m2
  raw[["group"]]  <-  paste(raw[["group"]], raw[["location"]], raw[["contributor"]], sep="; ")
  
  raw
}


