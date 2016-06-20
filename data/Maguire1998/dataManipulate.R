manipulate <- function(raw) {
  names(raw)[names(raw)=="species"]  <-  "wrong.sp"
  
  # h_c was crownlength, should be height to crown base
  raw$h_c <- with(raw, h_t - h_c)
  
  # Leaf area was in error: already converted to all-sided area
  raw$a_lf <- raw$a_lf / (2 * 1.18)
  
  raw
}

