manipulate <- function(raw) {

  
  # geometric mean crown width
  raw$CW <- with(raw, sqrt(Cwalong * Cwacross))
  
  # crown width in mixed units
  raw$CW[raw$CW < 10] <- 100*raw$CW[raw$CW < 10]
  
  # zero fix
  raw$CW[raw$Cwalong == 0] <- NA
  
  # Species. 
  raw$speciesfix <- "Pinus taeda"
  raw$speciesfix[raw$Species2 == "S"] <- "Pinus elliottii"
  
  # DensityID contains stand density:
  raw$standdensity <- raw$DensityID
  raw$standdensity[raw$standdensity=="N"] <- "2990ha-1"
  raw$standdensity[raw$standdensity=="W"] <- "1334ha-1"
  
  # Silviculturalinputs, recode
  raw$Silviculturalinputs[raw$Silviculturalinputs == "H"] <- "High"
  raw$Silviculturalinputs[raw$Silviculturalinputs == "L"] <- "Low"
  
  # grouping
  raw$grouping <- makeGroups(raw, c("soil","Silviculturalinputs","standdensity","FamilyID"))
  
  # Coarse root biomass
  raw$CoarseR20[is.na(raw$CoarseR20)] <- 0
  raw$CoarseR40[is.na(raw$CoarseR40)] <- 0
  raw$Taproot[is.na(raw$Taproot)] <- 0
  raw$CoarseRoot[is.na(raw$CoarseRoot)] <- 0
  
  raw$coarseroot <- with(raw, CoarseR20 + CoarseR40 + Taproot + CoarseRoot)
  raw$coarseroot[raw$coarseroot == 0] <- NA
  
  
  
  raw
}

