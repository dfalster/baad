manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("wood.type"))
  raw           <-  raw[raw$sample=="LowerTrunk",]
  raw
}

