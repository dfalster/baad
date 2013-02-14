#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  names(raw)[names(raw)=="map.mm"]  <-  "map"
  raw$reference  <-  "le Maire G, Marsden C, Verhoef W, Ponzoni FJ, Lo Seen D, Bégué A, Stape J-L, Nouvellon Y (2011) Leaf area index estimation with MODIS reflectance time series and model inversion during full rotations of Eucalyptus plantations. Remote Sensing of Environment 115:586–599."
  data      <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Variable.Unit, sep="; "), raw[,c(3,5:19,21:ncol(raw))], stringsAsFactors=FALSE)
}
