manipulate <- function(raw) {

  raw[["m.st"]]=raw[["AGB"]]-raw[["biomass leaf"]]
  raw
}
