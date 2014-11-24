manipulate <- function(raw) {
  raw           <-  raw[raw[["Source"]] == "Osada et al. (2003) Forest Ecology and Management", ]
  raw[["SLA"]]  <-  (1/raw[["SLA"]])*10000
  raw[["LMA"]]  <-  mapply(function(x,y){sum(c(x,y),na.rm=TRUE)},raw[["SLA"]],raw[["LMA"]])
  raw
}

