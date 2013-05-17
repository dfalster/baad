manipulate <- function(raw) {
  # leaf and biomass measurements come from different individuals, so I'll take 
  # the average leaf measure from each variable and species and then paste this 
  # into the individual trees that contain the biomass data
  raw1       <-  raw[!is.na(raw[["tree"]]), 1:6]
  raw1.mean  <-  
    data.frame(individual.leaf.mass.g=
                 tapply(raw1[["individual.leaf.mass.g"]], raw1[["species"]], mean),            
               individual.leaf.area.cm2=
                 tapply(raw1[["individual.leaf.area.cm2"]], raw1[["species"]], mean),
               specific.leaf.area.cm2.g=
                 tapply(raw1[["specific.leaf.area.cm2/g"]], raw1[["species"]], mean))
  
  raw       <-  raw[!is.na(raw[["biomass.samples"]]), c(1,4:16)]
  
  raw[["individual.leaf.mass.g"]] <- raw1.mean[match(raw[["species"]], rownames(raw1.mean)),
                                                    "individual.leaf.mass.g"]
  raw[["individual.leaf.area.cm2"]] <- raw1.mean[match(raw[["species"]], rownames(raw1.mean)), 
                                                  "individual.leaf.area.cm2"]
  raw[["specific.leaf.area.cm2/g"]] <- raw1.mean[match(raw[["species"]], rownames(raw1.mean)), 
                                                    "specific.leaf.area.cm2.g"]
  raw[["stem.biomass.g"]] <- raw[["branch.biomass.g"]] + raw[["trunk.biomass.g"]]
  rm(raw1)
  
  raw                            
  
  raw
}

