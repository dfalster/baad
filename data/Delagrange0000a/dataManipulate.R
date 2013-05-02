manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("plot_ID", "Subplot_ID"))
  raw
}

