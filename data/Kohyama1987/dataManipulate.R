manipulate <- function(raw) {
  raw[["leaf.mass"]]  <-  raw[["Wtl.g"]] + raw[["Wbl.g"]]
  raw[["m.st"]]       <-  raw[["Wts.g"]] + raw[["Wbs.g"]]
  raw[["D.av"]]       <-  0.5*(raw[["D1.cm"]] + raw[["D2.cm"]])
  # diameter measured at 1/10th of tree height, or on large trees with buttresses, above the buttress
  raw[["h.bh"]] <- 0.1 *  raw[["H.cm"]]

  raw
}

