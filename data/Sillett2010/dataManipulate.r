for(j in c(2,5:16)){
  raw[,j]    <-  unlist(lapply(raw[,j], function(x){as.numeric(strsplit(x, "_")[[1]][1])}))
}
raw$Tree     <-  unlist(lapply(gsub("s ", "s_", raw$Tree), function(x){strsplit(x, "_")[[1]][1]}))  