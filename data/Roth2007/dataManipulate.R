manipulate <- function(raw) {
  names(raw)[names(raw)=="species"]  <-  "wrong.sp"
  
  raw$grouping <- paste("Soiltype=", raw$remark)
  
  # h_c was crown length, should be height to crown base
  raw$h_c <- with(raw, h_t - h_c)
  
  
  raw
}

