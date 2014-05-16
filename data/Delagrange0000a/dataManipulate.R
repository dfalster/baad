manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("plot_ID", "Subplot_ID"))
  
  # Remove two zeroes in a.lf
  raw$a.lf[raw$a.lf == 0] <- NA
  
  # h.c cannot be larger than h.t
  # set these to NA
  raw$h.c[raw$h.c >= raw$h.t] <- NA
  
  raw
}

