manipulate <- function(raw) {
  
  # fix zero crown length (make NA)
  i <- raw[["Total.height.of.plant..cm."]] - raw[["Height.to.crown.base..cm."]] ==0
  raw[["Height.to.crown.base..cm."]][i] <- NA
  raw[["Crown.lenght..cm."]][i] <- NA
  
  raw
}

