manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("Site", "Seedbed"))
  
  # Remove one zero in a.lf
  raw$a.lf[raw$a.lf == 0] <- NA
  
  
  # zero d_bh is NA (note: zero dbh is possible when h.c < 1.4 or 1.3).
  raw$diameter[raw$diameter == 0] <- NA
  
  raw
}

