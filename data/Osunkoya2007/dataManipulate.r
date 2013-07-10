manipulate <- function(raw) {
  raw$grouping  <-  makeGroups(raw, c("Tree_no","growth_form"))
  
  raw[raw == "#NULL!"] <- NA
  
  # Two bad values in crown area ("" and "0")
  raw$crown_sil_area[raw$crown_sil_area %in% c("0","")] <- NA
  
  raw
}

