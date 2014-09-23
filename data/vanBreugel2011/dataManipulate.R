manipulate <- function(raw) {

  raw$grouping <- makeGroups(raw, "grouping")

  ii <- which(raw$h.c == raw$h.t)
  raw$h.c[ii] <- NA
  ii <- which(raw$c.d == 0)
  raw$c.d[ii] <- NA
  
  raw
}
