manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("Site", "Seedbed"))
  
  # Remove one zero in a.lf
  raw$a.lf[raw$a.lf == 0] <- NA
  
  raw
}

