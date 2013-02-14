#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw        <-  raw[raw$Source == "Osada et al. (2003) Forest Ecology and Management", ]
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Source, raw$Tree.No., sep="; "), raw[,c(4:9, 11:12, 14:ncol(raw))], stringsAsFactors=FALSE)
}
