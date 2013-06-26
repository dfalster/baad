manipulate <- function(raw) {
  # leaf and biomass measurements come from different individuals, so I'll take 
  # the average leaf measure from each variable and species and then paste this 
  # into the individual trees that contain the biomass data
  
  # species level data (leaf vars)
  raw1       <-  raw[!is.na(raw[["tree"]]), 1:6]
  raw1.mean  <-  aggregate(raw1[,c("individual.leaf.mass.g","individual.leaf.area.cm2","specific.leaf.area.cm2/g")],
                           by=list(raw1$species),
                           FUN=mean)
  names(raw1.mean) <- c("species","individual.leaf.mass.g","individual.leaf.area.cm2","specific.leaf.area.cm2/g")
    
  # individual level data (biomass vars)
  raw       <-  raw[!is.na(raw[["biomass.samples"]]), c(1,7:16)]
  
  # merge
  raw <- merge(raw, raw1.mean, by="species")

  raw[["stem.biomass.g"]] <- raw[["branch.biomass.g"]] + raw[["trunk.biomass.g"]]
  
  raw
}

