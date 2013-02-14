#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$species  <-  gsub("P.", "Psychotria", raw$species)
  data     <-  cbind(dataset=studyName, species=raw$species, grouping=raw$treatment, raw[,c(3:12)], growingCondition="FE", vegetation="TropRF", pft="EA", location="Barro Colorado Island (BCI, Panama)", latitude=9.15, longitude=-79.85, stringsAsFactors=FALSE)
}
