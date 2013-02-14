#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$vegetation[raw$species=="Anacardium excelsum"]    <-  "TropRF"
  raw$vegetation[raw$species=="Cordia alliodora"]       <-  "TropRF"
  raw$vegetation[raw$species=="Ficus insipida"]         <-  "TropRF"
  raw$vegetation[raw$species=="Luehea seemannii"]       <-  "TropRF"
  raw$vegetation[raw$species=="Acer circinatum"]        <-  "TemF"
  raw$vegetation[raw$species=="Acer macrophyllum"]      <-  "TemF"
  raw$vegetation[raw$species=="Alnus rubra"]            <-  "TemF"
  raw$vegetation[raw$species=="Arbutus menziesii"]      <-  "TemF"
  raw$vegetation[raw$species=="Fraxinus nigra"]         <-  "TemF"
  raw$vegetation[raw$species=="Quercus ellipsoidalis"]  <-  "TemF"
  raw$vegetation[raw$species=="Robinia pseudoacacia"]   <-  "TemF"
  raw$vegetation[raw$species=="Abies grandis"]          <-  "TemF"
  raw$vegetation[raw$species=="Pinus ponderosa"]        <-  "TemF"
  raw$vegetation[raw$species=="Pseudotsuga menziesii"]  <-  "TemF"
  raw$vegetation[raw$species=="Thuja plicata"]          <-  "TemF"
  raw$vegetation[raw$species=="Tsuga heterophylla"]     <-  "TemF"
  raw$latitude[raw$species=="Anacardium excelsum"]    <-  9
  raw$latitude[raw$species=="Cordia alliodora"]       <-  9
  raw$latitude[raw$species=="Ficus insipida"]         <-  9
  raw$latitude[raw$species=="Luehea seemannii"]       <-  9
  raw$latitude[raw$species=="Acer circinatum"]        <-  45
  raw$latitude[raw$species=="Acer macrophyllum"]      <-  45
  raw$latitude[raw$species=="Alnus rubra"]            <-  45
  raw$latitude[raw$species=="Arbutus menziesii"]      <-  45
  raw$latitude[raw$species=="Fraxinus nigra"]         <-  45
  raw$latitude[raw$species=="Quercus ellipsoidalis"]  <-  45
  raw$latitude[raw$species=="Robinia pseudoacacia"]   <-  45
  raw$latitude[raw$species=="Abies grandis"]          <-  45
  raw$latitude[raw$species=="Pinus ponderosa"]        <-  45
  raw$latitude[raw$species=="Pseudotsuga menziesii"]  <-  45
  raw$latitude[raw$species=="Thuja plicata"]          <-  45
  raw$latitude[raw$species=="Tsuga heterophylla"]     <-  45
  raw$longitude[raw$species=="Anacardium excelsum"]    <-  -79
  raw$longitude[raw$species=="Cordia alliodora"]       <-  -79
  raw$longitude[raw$species=="Ficus insipida"]         <-  -79
  raw$longitude[raw$species=="Luehea seemannii"]       <-  -79
  raw$longitude[raw$species=="Acer circinatum"]        <-  -123
  raw$longitude[raw$species=="Acer macrophyllum"]      <-  -123
  raw$longitude[raw$species=="Alnus rubra"]            <-  -123
  raw$longitude[raw$species=="Arbutus menziesii"]      <-  -123
  raw$longitude[raw$species=="Fraxinus nigra"]         <-  -93
  raw$longitude[raw$species=="Quercus ellipsoidalis"]  <-  -93
  raw$longitude[raw$species=="Robinia pseudoacacia"]   <-  -93
  raw$longitude[raw$species=="Abies grandis"]          <-  -123
  raw$longitude[raw$species=="Pinus ponderosa"]        <-  -123
  raw$longitude[raw$species=="Pseudotsuga menziesii"]  <-  -123
  raw$longitude[raw$species=="Thuja plicata"]          <-  -123
  raw$longitude[raw$species=="Tsuga heterophylla"]     <-  -123
  
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$wood.type, raw$collection.site, raw$sample, sep="; "), raw[,c(6,8,13,14)], growingCondition="FW", stringsAsFactors=FALSE)
}
