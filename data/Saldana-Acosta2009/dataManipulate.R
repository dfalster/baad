manipulate <- function(raw) {

  # A number of rows in this dataset had only initial height, no other vars.
  # Delete these.
  raw <- raw[raw[["Final height (cm)"]] > 0,]
  
  raw
}
