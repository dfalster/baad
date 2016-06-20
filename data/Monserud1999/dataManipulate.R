manipulate <- function(raw) {
  names(raw)[names(raw)=="species"]  <-  "wrong.sp"
  
  # h_c was crown length, should be height to crown base
  raw$h_c <- with(raw, h_t - h_c)
  
  # Included leaf areas were mistakenly converted to all-sided area. Re-convert here.
  raw$a_lf[raw$species == "PIMO"] <- raw$a_lf[raw$species == "PIMO"] / (1.18*2)
  raw$a_lf[raw$species == "PIPO"] <- raw$a_lf[raw$species == "PIPO"] / (1.18*2)
  raw$a_lf[raw$species == "PSME"] <- raw$a_lf[raw$species == "PSME"] / (1.19*2)
  
  
  raw
}

