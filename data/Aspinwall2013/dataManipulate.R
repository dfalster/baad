manipulate <- function(raw){


  raw$grouping  <-  makeGroups(raw, c("genlev","genotype", "rep"))

  raw$totroot <- with(raw, coarserootdw + taprootdw)


raw
}
