manipulate <- function(raw) {
  
  raw$grouping <- makeGroups(raw, c("CO2", "Temp")) 
  raw$Narea  <-  raw$Narea*raw$LA*0.0001/raw$LeafDW
  raw
}

