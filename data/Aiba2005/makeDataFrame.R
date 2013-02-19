#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data  <-  cbind(dataset=studyName, 
                  species=paste(raw$Genus, raw$Species), 
                  raw[,2:12], 
                  pft="EA", 
                  growingCondition="FW", 
                  longitude=5.104833, 
                  latitude=114.605,  
                  vegetation="TropRF", 
                  map=2700, 
                  mat=26, 
                  light="closed[average 6%]", 
                  location="Lambir Hills National Park, Sarawak, Malaysia", 
                  reference="Aiba M, Nakashizuka T (2005) Sapling structure and regeneration strategy in 18 Shorea sSpecies co-occurring in a tropical rainforest. Annals of Botany 96:313–321.", 
                  stringsAsFactors=FALSE)  
}
