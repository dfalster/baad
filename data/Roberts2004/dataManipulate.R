manipulate <- function(raw) {
  names(raw)[names(raw)=="species"]  <-  "wrong.sp"
  raw
}

