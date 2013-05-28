manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("plot_ID", "Subplot_ID"))
  
  # Remove two zeroes in a.lf
  raw$a.lf[raw$a.lf == 0] <- NA
  
  raw
}

