#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$spp[raw$spp=='acru']  <-  "Acer rubrum L."
  raw$spp[raw$spp=='bele']  <-  "Betula lento. L."
  raw$spp[raw$spp=='caov']  <-  "Carya ovata (Mill.) K. Koch"
  raw$spp[raw$spp=='cofl']  <-  "Cornus florida L."
  raw$spp[raw$spp=='litu']  <-  "Liriodendron tulipifera L."
  raw$spp[raw$spp=='oxar']  <-  "Oxydendrum arboreum (L.) DC."
  raw$spp[raw$spp=='qual']  <-  "Quercus alba L."
  raw$spp[raw$spp=='quco']  <-  "Quercus coccinea Muenchh."
  raw$spp[raw$spp=='qupr']  <-  "Quercus prinus L."
  raw$spp[raw$spp=='quru']  <-  "Quercus rubra L."
  raw$N.lf   <-  (raw$N.lf/100)*raw$LMA #transforms from percentage to the units of LMA so it can later be converted into kg/m2
  data   <-  cbind(dataset=studyName, species=raw$spp, grouping=paste("Filter = ", raw$Filter, sep=""), raw[,3:ncol(raw)], latitude=35, longitude=-83, map=2035, vegetation="TempRf", growingCondition="FW", pft="DA", stringsAsFactors=FALSE)
}
