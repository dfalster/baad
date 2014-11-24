manipulate <- function(raw) {

  
  # m.st includes stem, bark, and branches
  raw$mst <- raw[["STEMWOOD (kg)"]] + raw[["STEMBARK (kg)"]] + 
    raw[["BRANCH (kg)"]]
  
  raw
}

