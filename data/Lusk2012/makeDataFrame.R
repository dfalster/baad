#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$pft    <-  "EA"
  raw$pft[raw$Species=="Podocarpus nubigena"]          <-  "EG"
  raw$pft[raw$Species=="Podocarpus salignus"]          <-  "EG"
  raw$pft[raw$Species=="Saxegothaea conspicua"]        <-  "EG"
  raw$pft[raw$Species=="Araucaria araucana"]           <-  "EG"
  raw$pft[raw$Species=="Agathis australis"]            <-  "EG"
  raw$pft[raw$Species=="Phyllocladus trichomanoides"]  <-  "EG"
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(6:ncol(raw))], growingCondition="FW",  vegetation="TempRf", location="Parque Nacional Puyehue, Chile", latitude=-40.65, longitude=-72.18, map=3500, stringsAsFactors=FALSE)
}
