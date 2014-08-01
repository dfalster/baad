manipulate <- function(raw) {

  raw$grouping <- makeGroups(raw, "grouping")

  raw
}
