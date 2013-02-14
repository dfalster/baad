#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  #leaf and biomass measurements come from different individuals, so I'll take the average leaf measure from each variable and species and then paste this into the individual trees that contain the biomass data
  raw1       <-  raw[!is.na(raw$tree),1:6]
  raw1.mean  <-  data.frame(individual.leaf.mass.g=tapply(raw1$individual.leaf.mass.g, raw1$species, mean),
                            individual.leaf.area.cm2=tapply(raw1$individual.leaf.area.cm2, raw1$species, mean),
                            specific.leaf.area.cm2.g=tapply(raw1$specific.leaf.area.cm2.g, raw1$species, mean))
  raw2       <-  raw[!is.na(raw$biomass.samples),c(1,4:16)]
  raw2$individual.leaf.mass.g    <-  raw1.mean[match(raw2$species, rownames(raw1.mean)), "individual.leaf.mass.g"]
  raw2$individual.leaf.area.cm2  <-  raw1.mean[match(raw2$species, rownames(raw1.mean)), "individual.leaf.area.cm2"]
  raw2$specific.leaf.area.cm2.g  <-  raw1.mean[match(raw2$species, rownames(raw1.mean)), "specific.leaf.area.cm2.g"]
  raw2$stem.biomass.g            <-  raw2$branch.biomass.g + raw2$trunk.biomass.g
  
  data   <-  cbind(dataset=studyName, species=raw2$species, raw2[,c(3,4,6:8,10:13,15)], longitude=-79.05222, latitude=9.325, growingCondition="FE", vegetation="TropRF", location="Sardinilla, Buena Vista region, Panama", reference="Coll L, Potvin C, Messier C, Delagrange S (2008) Root architecture and allocation patterns of eight native tropical species with different successional status used in open-grown mixed plantations in Panama. Trees 22:585–596.", stringsAsFactors=FALSE)
}
