manipulate <- function(raw) {
  
  # zero d_bh is NA (note: zero dbh is possible when h.c < 1.4 or 1.3).
  raw$dbh[raw$dbh == 0] <- NA
  
  raw
}

