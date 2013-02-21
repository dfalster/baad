names(raw)[2:3]  <-  c("Indonesian name", "Species")

for(j in 1:nrow(raw)){
  if(raw$Species[j]=="Acaman" | raw$Species[j]=="Albfal"){
    raw$sp_measure_envir[j]  <-  "monocultural stands"
  } else {
    raw$sp_measure_envir[j]  <-  "mixed agroforest plots"    		}			
}
raw$species=raw$Species, raw$grouping=paste(paste("Isolation_", raw$Isolated, sep=""), paste("Area Density_", raw$Dense, sep=""), raw$sp_measure_envir, sep="; ")