manipulate <- function(raw) {
  raw[["d.cr"]] <- 0.5*(raw[["d.cr"]]+raw[["d.cr"]])
  raw
}
