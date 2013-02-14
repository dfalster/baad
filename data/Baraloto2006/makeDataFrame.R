#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$SpID, grouping=paste("Soil(",raw$Soil,"); ", "H2O(", raw$H2O, "); ", "P(", raw$P, ")", sep=""), raw[,c(6,7,10:14,16:17)], growingCondition="GH", longitude=-52.65034, latidude=5.159944, vegetation="TropRF", location="INRA, Kourou, French Guiana", reference="Baraloto C, Bonal D, Goldberg DE (2006) Differential seedling growth response to soil resource availability among nine neotropical tree species. Journal of Tropical Ecology 22:487–497.", stringsAsFactors=FALSE)
}
