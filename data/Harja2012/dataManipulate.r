for(j in 1:nrow(raw)){
  if(raw[["Species"]][j]=="Acaman" | raw[["Species"]][j]=="Albfal"){
    raw$sp_measure_envir[j]  <-  "monocultural stands"
  } else {
    raw$sp_measure_envir[j]  <-  "mixed agroforest plots"    		}			
}
raw$grouping                 <- makeGroups(raw, c("Isolated", "Dense", "sp_measure_envir"))

