#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  for(j in c(2,5:16)){
    raw[,j]  <-  unlist(lapply(raw[,j], function(x){as.numeric(strsplit(x, "_")[[1]][1])}))
  }
  raw$Tree   <-  unlist(lapply(gsub("s ", "s_", raw$Tree), function(x){strsplit(x, "_")[[1]][1]}))  
  raw$Tree[raw$Tree=="E. regnans"]       <-  "Eucalyptus regnans"  
  raw$Tree[raw$Tree=="S. sempervirens"]  <-  "Sequoia sempervirens"
  raw$location[raw$Tree=="Eucalyptus regnans"]      <-  "Wallaby Creek, Kinglake National Park, Victoria, Australia"
  raw$location[raw$Tree=="Sequoia sempervirens"]    <-  "Bull Creek, Humboldt Redwoods State Park, California, USA"
  raw$latitude[raw$Tree=="Eucalyptus regnans"]      <-  -37
  raw$latitude[raw$Tree=="Sequoia sempervirens"]    <-  145
  raw$longitude[raw$Tree=="Eucalyptus regnans"]     <-  40
  raw$longitude[raw$Tree=="Sequoia sempervirens"]   <-  -124
  raw$map[raw$Tree=="Eucalyptus regnans"]           <-  1208
  raw$map[raw$Tree=="Sequoia sempervirens"]         <-  1226
  raw$mat[raw$Tree=="Eucalyptus regnans"]           <-  11.6
  raw$mat[raw$Tree=="Sequoia sempervirens"]         <-  12.6
  data   <-  cbind(dataset=studyName, species=raw$Tree, raw[,c(2:5,10,11,14,19:23)], growingCondition="FW",  pft="EA", vegetation="TempF", stringsAsFactors=FALSE)
}
