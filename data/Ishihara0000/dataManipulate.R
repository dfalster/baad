manipulate <- function(raw) {
  
  
  
  raw$Age[raw$Age == "33-34"] <- "33.5"
  raw$Age[raw$Age == "22-23"] <- "22.5"
  raw$Age <- as.numeric(raw$Age)
  
  D0true <- with(raw, (D0 + D0.2)/2 )
  raw$D0[!is.na(raw$D0.2)] <- D0true[!is.na(raw$D0.2)]
  
  DBHtrue <- with(raw, (DBH + DBH.2)/2 )
  raw$DBH[!is.na(raw$DBH.2)] <- DBHtrue[!is.na(raw$DBH.2)]
  
  DLtrue <- with(raw, (DL + DL.2)/2 )
  raw$DL[!is.na(raw$DL.2)] <- DLtrue[!is.na(raw$DL.2)]
  raw$a.stbc <- (pi/4) * raw$DL^2
  
  # Separate stem mass from branch mass:
  raw$WS <- raw$WSB - raw$WB
  
  
  raw$SiteStand <- paste(raw$Country, raw$Site, raw$Stand, sep="-")
  
  raw$Forest.type[raw$Forest.type == "S?"] <- "S"
  
  raw$Ref2 <- paste("Ishihara0000", raw$Ref, sep="-")
  raw
}

