manipulate <- function(raw) {
  names(raw)[names(raw)=="species"]  <-  "wrong.sp"
  
  # h_c was crown length, should be height to crown base
  raw$h_c <- with(raw, h_t - h_c)
  
  raw
}

