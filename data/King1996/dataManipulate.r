manipulate <- function(raw){
  # diameter measured at 1/10th of tree height, or on large trees with buttresses, above the buttress
  raw[["h.bh"]] <- 0.1 *  raw[["Height (m)"]]
  raw
}
