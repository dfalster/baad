manipulate <- function(raw) {
  raw$status <- NA
  raw$status[which(raw$growth_form=="canopy")] <- 3
  raw$status[which(raw$growth_form=="subcanopy")] <- 1
  raw$status[which(raw$growth_form=="understorey")] <- 0
  
  raw$grouping  <-  makeGroups(raw, "growth_form")
  
  raw[raw == "#NULL!"] <- NA
  
  # Two bad values in crown area ("" and "0")
  raw$crown_sil_area[raw$crown_sil_area %in% c("0","")] <- NA
  
  raw
}

