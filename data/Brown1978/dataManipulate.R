manipulate <- function(raw) {
  names(raw)[names(raw)=="species"]  <-  "wrong.sp"
  
  # pft, all ae
  raw$pft <- "EG"
  raw$pft[raw$species == "LAOC"] <- "DG"
  
  
  raw
}

