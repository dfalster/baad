manipulate <- function(raw){

  # From author's notes:
  # identifies the genetic 'level' of the genotypes in the study; 
  # 'cl' = clone, 'fs' = full-sib family, 'hs' = half-sib family
  # indentity of each genotype, 
  # c1, c2, and c3 represent clone 1, clone 2 and clone 3, 
  # fs1, fs2 and fs3 = fullsib family 1, fullsib family 2, and full-sib family 3 etc.
  raw$grouping  <-  makeGroups(raw, c("genlev","genotype", "rep"))

  raw$totroot <- with(raw, coarserootdw + taprootdw)


raw
}
