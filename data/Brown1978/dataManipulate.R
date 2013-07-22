manipulate <- function(raw) {
  names(raw)[names(raw)=="species"]  <-  "wrong.sp"
  
  
  # h_c is crown length; should be height to crownbase
  raw$h_c <- with(raw, h_t - h_c)
  
  # zero d_bh is NA (note: zero dbh is possible when h.c < 1.4 or 1.3).
  raw$dbh[raw$dbh == 0] <- NA
  
  raw
}

