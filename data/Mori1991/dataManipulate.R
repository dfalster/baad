manipulate <- function(raw) {
  raw[raw=="No data"] <-  NA
  
  raw
}

