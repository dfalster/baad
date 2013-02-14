#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw        <-  raw[raw$reference=="Selaya et al. (2008) Journal of Ecology 96: 1211-1221; Selaya & Anten (2010) Ecology 91:1102-1113",]
  raw$light  <-  raw$light/55*100
  data   <-  cbind(dataset=studyName, species=raw$Species, grouping=raw$group..7., raw[,c(4:16,18,19,25:ncol(raw))], growingCondition="PU",  latitude=-11, longitude=-66, location="Riberalta, Bolivian Amazon", stringsAsFactors=FALSE)
}
