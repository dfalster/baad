manipulate <- function(raw) {
  
  raw[["d.cr"]] <- 0.5*(raw[["d.cr"]]+raw[["d.cr2"]])
  
  raw$c.d[raw$c.d == 0] <- NA
  
  raw
}
