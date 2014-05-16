manipulate <- function(raw) {
  raw        <-  raw[raw[["reference"]]=="Selaya et al. (2008) Journal of Ecology 96: 1211-1221; Selaya & Anten (2010) Ecology 91:1102-1113",]
  raw[["light"]]  <-  raw[["light"]]/55*100

  # Fix grouping. This info is also in 'age', but repeat it here to be safe.
  names(raw)[names(raw) == "group..7."] <- "grouping"
  raw$grouping <- makeGroups(raw, "grouping")
  
  # Massive outlier : wrong stem area measurement
  raw$a.st[raw$a.st > 0.2] <- NA
  
  # Zero
  raw$a.st[raw$a.st == 0] <- NA
  
  # Mistake in original processing and a zero fix
  raw$h.c <- raw$h.t - raw$h.c
  raw$h.c[raw$h.c > raw$h.t] <- NA
  
  raw
}

