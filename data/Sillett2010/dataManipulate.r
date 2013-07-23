manipulate <- function(raw) {
 
  # remove std error values given in table
  for(j in c(2,5:16)){
    raw[,j]    <-  unlist(lapply(raw[,j], function(x){as.numeric(strsplit(x, "_")[[1]][1])}))
  }

  #remove numbers from Tree label
  raw[["Tree"]]     <-  unlist(lapply(gsub("s ", "s_", raw[["Tree"]]), function(x){strsplit(x, "_")[[1]][1]}))  
  
  # stem mass - difference between total and leaf
  raw$m.st <- (raw[["Dry mass (Mg)"]]*1000 - raw[["Leaf dry mass (kg)"]])
   
  raw
}

