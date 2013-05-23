manipulate <- function(raw) {
  names(raw)[names(raw)=="species"]  <-  "wrong.sp"
  
  raw$grouping <- paste("Soiltype=", raw$remark)
  
  raw
}

