manipulate <- function(raw) {
  raw[["m.rc"]]       <-  raw[["Lrg. Root"]] + raw[["Med. Root"]]
  raw[["Stem Wood"]]  <-  raw[["Stem Wood"]] + raw[["Stem Bark"]]

  # zero d_bh is NA (note: zero dbh is possible when h.c < 1.4 or 1.3).
  d0 <- raw[["D.B.H.(mm)"]] == 0
  raw[["D.B.H.(mm)"]][d0] <- NA
  
  raw
}

