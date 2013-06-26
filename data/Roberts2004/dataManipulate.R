manipulate <- function(raw) {
  
  
  raw$grouping <- as.factor(raw$Treat)
  levels(raw$grouping) <- paste("Poultry litter =",c(0,6,23),"Mg ha-1")
  
  raw$cw <- with(raw, (CW1 + CW2)/2)
  
  raw
}

