manipulate <- function(raw) {
  raw[["Bark_Stemwood"]] <-  raw[["Bark"]] + raw[["Stemwood"]]
  
  # To be consistent with publication Table 1.
  raw$Treatment <- paste0("T", raw$Treatment)
  raw$grouping <- makeGroups(raw, "Treatment")
  
  raw
}

