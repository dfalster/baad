#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$SpecCode[raw$SpecCode=='Swinto,']  <-  "Swintonia schwenkii"
  raw$SpecCode[raw$SpecCode=='Shorea,']  <-  "Shorea sumatrana"
  raw$SpecCode[raw$SpecCode=='Nephel,']  <-  "Nephelium juglandifolium"
  raw$SpecCode[raw$SpecCode=='Hopeam,']  <-  "Hopea dryobalanoides"
  raw$SpecCode[raw$SpecCode=='Mastix,']  <-  "Mastixia trichotoma"
  raw$SpecCode[raw$SpecCode=='Phylla,']  <-  "Cleistanthus glandulosus"
  raw$SpecCode[raw$SpecCode=='Grewia,']  <-  "Grewia florida"
  raw$SpecCode[raw$SpecCode=='Gonyst,']  <-  "Gonystylus forbesii"
  raw$SpecCode[raw$SpecCode=='Diosum,']  <-  "Diospyrus sumatrana"
  data   <-  cbind(dataset=studyName, species=raw$SpecCode, grouping=paste(raw$Year,raw$X., sep="; "), raw[,c(4:5, 8:10, 16:ncol(raw))], latitude=-0.9166667, longitude=100.5, map=4760, growingCondition="FW", vegetation="TropRF", location="Ulu Gadut valley, Padang, Sumatra, Indonesia", reference="Kohyama T, Hotta M (1990) Significance of allometry in tropical saplings. Functional Ecology 4(4):515–521.", stringsAsFactors=FALSE)
}
