manipulate <- function(raw) {
 
  # remove std error values given in table
  for(j in c(2,5:16)){
    raw[,j]    <-  unlist(lapply(raw[,j], function(x){as.numeric(strsplit(x, "_")[[1]][1])}))
  }

  #remove numbers from Tree label
  raw[["Tree"]]     <-  unlist(lapply(gsub("s ", "s_", raw[["Tree"]]), function(x){strsplit(x, "_")[[1]][1]}))  
  
  
  # stem mass - difference between total and leaf
  raw$m.st <- (raw[["Dry mass (Mg)"]]*1000 - raw[["Leaf dry mass (kg)"]])
  
  # Wood density - stem mass / volume
  raw$r.st <- raw$m.st/(raw[["Bark volume (m3)"]]+raw[["Heartwood volume (m3)"]]+raw[["Sapwood volume (m3)"]]+raw[["Decaying wood volume (m3)"]])
  
  # Sapwood mass
  raw$m.ss <- raw[["Sapwood volume (m3)"]] *  raw$r.st 
  #Heartwood mass  
  raw$m.sh <-(raw[["Heartwood volume (m3)"]]+raw[["Decaying wood volume (m3)"]]) *  raw$r.st 
  #Bark mass
  raw$m.sb <- raw[["Sapwood volume (m3)"]] *  raw$r.st 
  
  raw
}

