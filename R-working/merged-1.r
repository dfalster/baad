 
data/Aiba2005
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data  <-  cbind(dataset=studyName, 
                  species=paste(raw$Genus, raw$Species), raw[,2:12], pft="EA", growingCondition="FW", longitude=5.104833, latitude=114.605,vegetation="TropRF", map=2700, mat=26, light="closed[average 6%]", 
                  location="Lambir Hills National Park, Sarawak, Malaysia", reference="Aiba M, Nakashizuka T (2005) Sapling structure and regeneration strategy in 18 Shorea sSpecies co-occurring in a tropical rainforest. Annals of Botany 96:313–321.", stringsAsFactors=FALSE)  
}
 
data/Aiba2007
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$total.stem.mass..g.  <-  raw$branch.mass...stem.mass..g.
  data       <-  cbind(dataset=studyName, species=paste(raw$genus, raw$species), raw[,c(3:5,7:13)], growingCondition="FW", vegetation="TropRF", pft="EA", location="Lambir Hills National Park, Sarawak, Malaysia", latitude=4.03, longitude=113.83, map=2700, mat=26, stringsAsFactors=FALSE)
}
 
data/Baltzer2007
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$species[raw$species=="AR"]  <-  "Acer rubrum"
  raw$species[raw$species=="AS"]  <-  "Acer saccharum"
  raw$species[raw$species=="BA"]  <-  "Betula alleghaniensis"
  raw$species[raw$species=="FA"]  <-  "Fraxinus americana"
  raw$species[raw$species=="QR"]  <-  "Quercus rubra"
  raw$species[raw$species=="UA"]  <-  "Ulmus americana"
  raw$species[raw$species=="BP"]  <-  "Betula papyrifera"
  names(raw)[names(raw) == "Plant.functional.type"]    <-  "pft"
  names(raw)[names(raw) == "Growing.condition"]        <-  "growingCondition"
  raw$reference                                        <-  "Baltzer JL, Thomas SC (2007) Physiological and morphological correlates of whole-plant light compensation point in temperate deciduous tree seedlings. Oecologia 153:209–223."
  data   <-  cbind(dataset=studyName, species=raw$species, raw[,c(4:16,18,21:24)], latitude=43.66146, longitude=-79.40006, stringsAsFactors=FALSE)
}
 
data/Baraloto2006
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$SpID, grouping=paste("Soil(",raw$Soil,"); ", "H2O(", raw$H2O, "); ", "P(", raw$P, ")", sep=""), raw[,c(6,7,10:14,16:17)], growingCondition="GH", longitude=-52.65034, latidude=5.159944, vegetation="TropRF", location="INRA, Kourou, French Guiana", reference="Baraloto C, Bonal D, Goldberg DE (2006) Differential seedling growth response to soil resource availability among nine neotropical tree species. Journal of Tropical Ecology 22:487–497.", stringsAsFactors=FALSE)
}
 
data/Bond-Lamberty2002
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Species[raw$Species=='A']   <-  "Populus tremuloides"
  raw$Species[raw$Species=='BI']  <-  "Betula papyrifera"
  raw$Species[raw$Species=='BS']  <-  "Picea mariana"
  raw$Species[raw$Species=='JP']  <-  "Pinus banksiana"
  raw$Species[raw$Species=='T']   <-  "Larix laricina"
  raw$Species[raw$Species=='W']   <-  "Salix spp"
  data   <-  cbind(dataset=studyName, 
                   grouping=paste(raw$Site, raw$HarvestYear, raw$Edaphic, sep="; "), 
                   species=raw$Species, 
                   age=raw$HarvestYear-raw$BurnYear, 
                   stemMass=raw$TotBranch+raw$Stem, 
                   raw[,c("Height", "D0", "DBH", "TotFol", "Sapwood", "Root")], 
                   longitude=raw$longitude, 
                   latitude=raw$latitude, 
                   growingCondition="FW", 
                   vegetation="BorF", 
                   location="Near Thompson and Leaf Rapids, Manitoba, Canada", 
                   reference="Bond-Lamberty B, Wang C, Gower ST (2002) Aboveground and belowground biomass and sapwood area allometric equations for six boreal tree species of northern Manitoba. Canadian Journal of Forest Research 32:1441–1450.", 
                   stringsAsFactors=FALSE)

}
 
data/Coll2008
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  #leaf and biomass measurements come from different individuals, so I'll take the average leaf measure from each variable and species and then paste this into the individual trees that contain the biomass data
  raw1       <-  raw[!is.na(raw$tree),1:6]
  raw1.mean  <-  data.frame(individual.leaf.mass.g=tapply(raw1$individual.leaf.mass.g, raw1$species, mean),
                            individual.leaf.area.cm2=tapply(raw1$individual.leaf.area.cm2, raw1$species, mean),
                            specific.leaf.area.cm2.g=tapply(raw1$specific.leaf.area.cm2.g, raw1$species, mean))
  raw2       <-  raw[!is.na(raw$biomass.samples),c(1,4:16)]
  raw2$individual.leaf.mass.g    <-  raw1.mean[match(raw2$species, rownames(raw1.mean)), "individual.leaf.mass.g"]
  raw2$individual.leaf.area.cm2  <-  raw1.mean[match(raw2$species, rownames(raw1.mean)), "individual.leaf.area.cm2"]
  raw2$specific.leaf.area.cm2.g  <-  raw1.mean[match(raw2$species, rownames(raw1.mean)), "specific.leaf.area.cm2.g"]
  raw2$stem.biomass.g            <-  raw2$branch.biomass.g + raw2$trunk.biomass.g
  
  data   <-  cbind(dataset=studyName, species=raw2$species, raw2[,c(3,4,6:8,10:13,15)], longitude=-79.05222, latitude=9.325, growingCondition="FE", vegetation="TropRF", location="Sardinilla, Buena Vista region, Panama", reference="Coll L, Potvin C, Messier C, Delagrange S (2008) Root architecture and allocation patterns of eight native tropical species with different successional status used in open-grown mixed plantations in Panama. Trees 22:585–596.", stringsAsFactors=FALSE)
}
 
data/Delagrange2004
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$total.stem.mass..g.  <-  raw$branch.mass...stem.mass..g.
  raw$Reference            <-  "Delagrange S, Messier C, Lechowicz MJ, Dizengremel P (2004) Physiological, morphological and allocational plasticity in understory deciduous trees: importance of plant size and light availability. Tree Physiology 24:775–784."
  data                 <-  cbind(dataset=studyName, species=raw$Species, grouping=paste(raw$Group, "; Last perturbation = ", raw$Last.perturbation, sep=""), raw[,c(2,4:21,23:29)], stringsAsFactors=FALSE)
}
 
data/Domec2012
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  names(raw)[names(raw)=="Reference.publication"]  <-  "reference"
  raw$reference[raw$reference %in% c(unique(raw$reference)[1:6])]  <-  "Domec J-C, Gartner BL (2003) Relationship between growth rates and xylem hydraulic characteristics in young, mature and old-growth ponderosa pine trees. Plant, Cell and Environment 26:471–483; Domec, J-C, Lachenbruch B, Pruyn ML, Spicer R (2012) Effects of age-related increases in sapwood area, leaf area, and xylem conductivity on height-related hydraulic costs in two contrasting coniferous species. Annals of Forest Science 69:17–27."
  raw$reference[raw$reference %in% c(unique(raw$reference)[2:13])]  <- "Domec J-C, Pruyn ML, Gartner BL (2005) Axial and radial proﬁles in conductivities, water storage and native embolism in trunks of young and old-growth ponderosa pine trees. Plant, Cell and Environment 28:1103–1113; Domec, J-C, Lachenbruch B, Pruyn ML, Spicer R (2012) Effects of age-related increases in sapwood area, leaf area, and xylem conductivity on height-related hydraulic costs in two contrasting coniferous species. Annals of Forest Science 69:17–27."
  raw$reference[raw$reference %in% c(unique(raw$reference)[3:13])]  <- "Domec J-C, Pruyn ML (2008) Bole girdling affects metabolic properties and root, trunk and branch hydraulics of young ponderosa pine trees. Tree Physiology 28(10):1493–1504; Domec, J-C, Lachenbruch B, Pruyn ML, Spicer R (2012) Effects of age-related increases in sapwood area, leaf area, and xylem conductivity on height-related hydraulic costs in two contrasting coniferous species. Annals of Forest Science 69:17–27."
  raw$reference[raw$reference %in% c(unique(raw$reference)[4:26])]  <- "Domec J-C, Gartner BL (2002) Age- and position-related changes in hydraulic versus mechanical dysfunction of xylem: inferring the design criteria for Douglas-fir wood structure. Tree Physiology 22:91–104; Domec, J-C, Lachenbruch B, Pruyn ML, Spicer R (2012) Effects of age-related increases in sapwood area, leaf area, and xylem conductivity on height-related hydraulic costs in two contrasting coniferous species. Annals of Forest Science 69:17–27."
  
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(3:12, 14:37, 39:45)], stringsAsFactors=FALSE)
}
 
data/Epron2012
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$a.babh <-  raw$a.st - raw$a.st.1
  names(raw)[names(raw)=="group"]  <-  "grouping"
  raw$reference  <-  "Epron D, Laclau J-P, Almeida JCR, Goncalves JLM, Ponton S, Sette Jr CR, Delgado-Rojas JS, Bouillet J-P, Nouvellon Y (2012) Do changes in carbon allocation account for the growth response to potassium and sodium applications in tropical Eucalyptus plantations? Tree Physiology 32:667–679; Almeida JCR, Laclau J-P, Goncalves JLM, Ranger J, Saint-Andre L (2010) A positive growth response to NaCl applications in Eucalyptus plantations established on K-deficient soils. Forest Ecology and Management 259:1786–1795; Laclau J-P unpublished."
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Variable, raw$contributor, raw$Nutrition, sep="; "), raw[,c(3, 6:10, 12:19, 22:ncol(raw))], stringsAsFactors=FALSE)
}
 
data/Harja2012
#Define a  function for that constructs dataframe for this study
#TODO: not finsihed?
makeDataFrame<-function(raw, studyName){
  names(raw)[2:3]  <-  c("Indonesian name", "Species")
  raw$Species[raw$Species=='Landom']  <-  "Lansium domesticum"
  raw$Species[raw$Species=='Durzib']  <-  "Durio zibethinus"
  raw$Species[raw$Species=='Hevbra']  <-  "Hevea brasiliensis"
  raw$Species[raw$Species=='Alssch']  <-  "Alstonia scholaris"
  raw$Species[raw$Species=='Schwal']  <-  "Schima wallichii"
  raw$Species[raw$Species=='Fagfra']  <-  "Fagraea fragrans"
  raw$Species[raw$Species=='Shoste']  <-  "Shorea stenoptera"
  raw$Species[raw$Species=='Pitjir']  <-  "Archidendron jiringa"
  raw$Species[raw$Species=='Acaman']  <-  "Acacia mangium"
  raw$Species[raw$Species=='Albfal']  <-  "Albizia falcataria"
  
  for(j in 1:nrow(raw)){
    if(raw$Species[j]=="Acacia mangium" | raw$Species[j]=="Albizia falcataria"){
      raw$sp_measure_envir[j]  <-  "monocultural stands"
    } else {
      raw$sp_measure_envir[j]  <-  "mixed agroforest plots"  			}			
  }
  data   <-  cbind(dataset=studyName, species=raw$Species, grouping=paste(paste("Isolation_", raw$Isolated, sep=""), paste("Area Density_", raw$Dense, sep=""), raw$sp_measure_envir, sep="; "), raw[,c(1, 5, 8, 10:11, 17:18)], growingCondition="FW", vegetation="TropRF", reference="Harja D, Vincent G, Mulia R, van Noordwijk M (2012) Tree shape plasticity in relation to crown exposure. Trees 26(4):1275–1285.", stringsAsFactors=FALSE)
}
 
data/Kenzo2009
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$n.lf.per  <-  (raw$n.lf.per/100) * raw$lf.ma.g.m2 # this transforms it from percentage (/unit mass) to /unit area --> final unit g/m2
  raw$reference[raw$reference %in% c(unique(raw$reference)[1])]  <-  "Kenzo T, Ichie T, Hattori D, Itioka T, Handa C, Ohkubo T, Kendawang JJ, Nakamura M, Sakaguchi M, Takahashi N, Okamoto M, Tanaka-Oda A, Sakurai K, Ninomiya I (2009) Development of allometric relationships for accurate estimation of above- and below-ground biomass in tropical secondary forests in Sarawak, Malaysia. Journal of Tropical Ecology 25:371–386."
  raw$reference[raw$reference %in% c(unique(raw$reference)[2])]  <-  "Kenzo T et al. 2008 unpublished"
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$group, raw$location, raw$contributor, sep="; "), raw[,c(2, 4:24, 26:ncol(raw))], stringsAsFactors=FALSE)
}
 
data/Kenzo2009b
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$location, raw$contributor, sep="; "), raw[,c(2, 4:ncol(raw))], stringsAsFactors=FALSE)
}
 
data/Kohyama1987
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$SpecCode[raw$SpecCode=='Cs']  <-  "Camellia sasanqua"
  raw$SpecCode[raw$SpecCode=='Cj']  <-  "Camellia japonia"
  raw$SpecCode[raw$SpecCode=='Na']  <-  "Neolitsea aciculata"
  raw$SpecCode[raw$SpecCode=='Sg']  <-  "Symplocos glauca"
  raw$SpecCode[raw$SpecCode=='Pn']  <-  "Podocarpus nagi"
  raw$SpecCode[raw$SpecCode=='Ia']  <-  "Illicium anisatsum"
  raw$SpecCode[raw$SpecCode=='Dr']  <-  "Distylium racemosum"
  raw$SpecCode[raw$SpecCode=='Ms']  <-  "Myrsine seguinii"
  raw$SpecCode[raw$SpecCode=='St']  <-  "Symplocos tanakae"
  raw$SpecCode[raw$SpecCode=='Sp']  <-  "Symplocos purnifolia"
  raw$SpecCode[raw$SpecCode=='Rt']  <-  "Rhododendron tashiroi"
  raw$SpecCode[raw$SpecCode=='La']  <-  "Litsea acuminata"
  raw$SpecCode[raw$SpecCode=='Cl']  <-  "Cleyera japonica"
  raw$SpecCode[raw$SpecCode=='Ej']  <-  "Eurya japonica"  	
  raw$leaf.mass  <-  raw$Wtl.g + raw$Wbl.g
  raw$m.st       <-  raw$Wts.g + raw$Wbs.g
  data   <-  cbind(dataset=studyName, species=raw$SpecCode, raw[,c(5:8, 14:ncol(raw))], latitude=30.31667, longitude=130.4333, location="Ohkou River, Yakushima Island, Kyushu, Japan", reference="Kohyama T (1987) Significance of architecture and allometry in saplings. Functional Ecology 1:399–404.", growingCondition="FW", vegetation="TempRf", stringsAsFactors=FALSE)
}
 
data/Kohyama1990
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
 
data/Kohyama1994
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$SpecCode[raw$SpecCode=='Cs']  <-  "Camellia sasanqua"
  raw$SpecCode[raw$SpecCode=='Cj']  <-  "Camellia japonia"
  raw$SpecCode[raw$SpecCode=='Na']  <-  "Neolitsea aciculata"
  raw$SpecCode[raw$SpecCode=='Sg']  <-  "Symplocos glauca"
  raw$SpecCode[raw$SpecCode=='Pn']  <-  "Podocarpus nagi"
  raw$SpecCode[raw$SpecCode=='Ia']  <-  "Illicium anisatsum"
  raw$SpecCode[raw$SpecCode=='Dr']  <-  "Distylium racemosum"
  raw$SpecCode[raw$SpecCode=='Ms']  <-  "Myrsine seguinii"
  raw$SpecCode[raw$SpecCode=='St']  <-  "Symplocos tanakae"
  raw$SpecCode[raw$SpecCode=='Sp']  <-  "Symplocos purnifolia"
  raw$SpecCode[raw$SpecCode=='Rt']  <-  "Rhododendron tashiroi"
  raw$SpecCode[raw$SpecCode=='La']  <-  "Litsea acuminata"
  raw$SpecCode[raw$SpecCode=='Cl']  <-  "Cleyera japonica"
  raw$SpecCode[raw$SpecCode=='Ej']  <-  "Eurya japonica"  	
  raw$SpecCode[raw$SpecCode=='Ci']  <-  "Eurya japonica"		
  raw$SpecCode[raw$SpecCode=='Sb']  <-  "??1"		
  raw$SpecCode[raw$SpecCode=='Daph.']   <-  "??2"		
  raw$SpecCode[raw$SpecCode=='Ardis.']  <-  "??3"		
  raw$SpecCode[raw$SpecCode=='Sarca.']  <-  "??4"		
  data   <-  cbind(dataset=studyName, species=raw$SpecCode, raw[,c(3:5, 10:ncol(raw))], latitude=30, longitude=130, growingCondition="FW", vegetation="TempRf", location="Yakushima Island, Kyushu, Japan", reference="Kohyama T, Grubb PJ (1994) Below- and above-ground allometries of shade-tolerant seedlings in a Japanese warm-temperate rain forest. Functional Ecology 8:229–236.", stringsAsFactors=FALSE)
}
 
data/Lusk0000a
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(6:ncol(raw))], growingCondition="GH",  pft="EA", location="New Zealand", stringsAsFactors=FALSE)
}
 
data/Lusk0000b
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(6:10)], growingCondition="GH", pft="EA", location="New Zealand", stringsAsFactors=FALSE)
}
 
data/Lusk2002
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(6:10)], growingCondition="FW",  vegetation="TempRf", pft="EA", location="Parque Nacional Puyehue, Chile", latitude=-40.65, longitude=-72.18, map=3500, stringsAsFactors=FALSE)
}
 
data/Lusk2004
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(6:10)], growingCondition="FW", vegetation="TempRf", pft="EA", location="Parque Nacional Puyehue, Chile", latitude=-40.65, longitude=-72.18, map=3500, stringsAsFactors=FALSE)
}
 
data/Lusk2011
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(6:ncol(raw))], growingCondition="FW",  vegetation="TempRf", location="Parque Nacional Puyehue, Chile", latitude=-40.65, longitude=-72.18, map=3500, stringsAsFactors=FALSE)
}
 
data/Lusk2012
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
 
data/Martin1998
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
 
data/McCulloh2010
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
 
data/Mokany2003
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(7:22)], reference=paste(raw$Name, raw$Year, raw$Title, raw$Symbol, sep=""), stringsAsFactors=FALSE)
}
 
data/Mori1991
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw[raw=="No data"] <-  NA
  data   <-  cbind(dataset=studyName, species="Chamaecyparis obtusa", raw[,c(2, 5, 10:17)], vegetation="TempF", growingCondition="PU", stringsAsFactors=FALSE)
}
 
data/Myster2009
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, raw[,c(2:6)], latitude=36.78333, longitude=-96.41667, map=820, vegetation="TempF", growingCondition="PM", stringsAsFactors=FALSE)
}
 
data/Nouvellon2010
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, raw[,c(5:ncol(raw))], stringsAsFactors=FALSE)
}
 
data/O'Grady2000
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$SPECIES[raw$SPECIES=="E.tet."]    <-  "Eucalyptus tetrodonta"
  raw$SPECIES[raw$SPECIES=="E.min."]    <-  "Eucalyptus miniata"
  raw$SPECIES[raw$SPECIES=="T.ferd."]   <-  "Terminalia ferdinandiana"
  raw$SPECIES[raw$SPECIES=="E.min"]     <-  "Eucalyptus miniata"
  raw$SPECIES[raw$SPECIES=="E.chlor."]  <-  "Erythrophloem chlorostachys"
  raw$SPECIES[raw$SPECIES=="E.clav."]   <-  "Eucalyptus clavigera"
  data  <-  cbind(dataset=studyName, species=raw$SPECIES, grouping=paste("Site = ", raw$SITE, sep=""), raw[,c(3,9,11,12,15)], latitude=-12.5, longitude=130.75, growingCondition="FW", pft="EA", vegetation="Sav", location="Howard Springs, NT, Australia", map=1700, stringsAsFactors=FALSE)
}
 
data/O'Grady2006
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Leaf.area  <-  raw$X
  raw$stem       <-  raw$stem+raw$branch
  raw$m.rf       <-  raw$X5.Oct + raw$Oct.15
  raw$m.rc       <-  raw$X15...20 + raw$X20....stump
  data  <-  cbind(dataset=studyName, species="Eucalyptus globulus", grouping=paste("Harvested on ", raw$Harvested, "; Plot = ", raw$plot, "; Treatment = ", raw$treatment, "; seedling = ", raw$seedling, sep=""), raw[,c(5,6,8:11,13,14,16,17,22,23)], latitude=-42.82, longitude=147.51, growingCondition="PM", pft="EA", location="Pittwater plantation, TAS, Australia", map=500, stringsAsFactors=FALSE)
}
 
data/O'Hara0000
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species="Sequoiadendron giganteum", raw[,c(2:4, 6:ncol(raw))], stringsAsFactors=FALSE)
}
 
data/O'Hara1995
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=raw$site, raw[,c(1:3, 5:7, 9)], vegetation="TempF", growingCondition="FW", stringsAsFactors=FALSE)
}
 
data/Osada0000
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw        <-  raw[raw$Source != "Osada et al. (2003) Forest Ecology and Management" & raw$Source != "Osada (2005) Canadian Journal of Botany", ]
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Source, raw$Tree.No., sep="; "), raw[,c(4:9, 11:12, 14:ncol(raw))], stringsAsFactors=FALSE)
}
 
data/Osada2003
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw        <-  raw[raw$Source == "Osada et al. (2003) Forest Ecology and Management", ]
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Source, raw$Tree.No., sep="; "), raw[,c(4:9, 11:12, 14:ncol(raw))], stringsAsFactors=FALSE)
}
 
data/Osada2005
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw        <-  raw[raw$Source == "Osada (2005) Canadian Journal of Botany", ]
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Source, raw$Tree.No., sep="; "), raw[,c(4:9, 11:12, 14:ncol(raw))], stringsAsFactors=FALSE)
}
 
data/Osunkoya2007
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$species[raw$species=="Horsfiel_polysph"]  <-  "Horsfieldia polyspherulaa"
  raw$species[raw$species=="Knema_ashiton"]     <-  "Knema ashitoniia"
  raw$species[raw$species=="Litsea_ferrugi"]    <-  "Litsea ferrugiinea"  	
  raw$species[raw$species=="Payena_unknown"]    <-  "Payena sp"		
  raw$species[raw$species=="Shorea_parvifol"]   <-  "Shorea parvifolia"		
  raw$species[raw$species=="Syz_sp_2"]          <-  "Syzygium sp."		
  raw$species[raw$species=="syzy_caudatumn"]    <-  "Syzygium caudatum"		
  raw$species[raw$species=="Dacryo_apicul"]     <-  "Dacryodes apiculatae"		
  raw$species[raw$species=="Dill_excelsa"]      <-  "Dillenia excelsa"		
  raw$species[raw$species=="Diosp_borneensis"]  <-  "Diospyros borneensis"		
  raw$species[raw$species=="Mal_sp_1"]          <-  "Mallotus sp."		
  raw$species[raw$species=="Noescor_kingi"]     <-  "Noescortechinia kingii"		
  raw$species[raw$species=="Ap_elemeri"]        <-  "Aporusa elemeri"		
  raw$species[raw$species=="Apo_grandi"]        <-  "Aporusa grandistipula"		
  raw$species[raw$species=="Apo_nitida"]        <-  "Aporusa subcaudata"		
  raw$species[raw$species=="Chionan_curvic"]    <-  "Chionanthus spicatusi"		
  raw$species[raw$species=="Ford_sp_3"]         <-  "Fordia sp."		
  raw$species[raw$species=="Ford_splendid"]     <-  "Fordia splendidissima"		
  raw$species[raw$species=="Ixora_grandif"]     <-  "Ixora grandifolia"		
  raw$species[raw$species=="Mal_ecaustus"]      <-  "Mallotus eucaustus"		
  raw$species[raw$species=="Mal_wrayei"]        <-  "Mallotus wreyi"		
  raw$species[raw$species=="Urophyl_arboret"]   <-  "Urophyllum arboreum"		
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Tree_no, raw$growth_form., sep="; "), raw[,c(7:12)], latitude=4.5, longitude=115.1667, map=5080, mat=30, growingCondition="FW", vegetation="TropRF", pft="EA", stringsAsFactors=FALSE)
}
 
data/Petritan2009
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(2:ncol(raw))], latitude=51.57944, longitude=10.03639, map=780, mat=7.8, growingCondition="FW", vegetation="TempF", pft="EA / DA", stringsAsFactors=FALSE)
}
 
data/Ribeiro2011
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  names(raw)[3]         <-  "family"
  names(raw)[15:17]     <-  c("location","map", "mat")
  names(raw)[13]        <-  "vegetation"
  names(raw)[14]        <-  "growingCondition"  
  raw$vegetation        <-  "TropSF (Savannah like)"
  raw$growingCondition  <-  "FW"
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(3:6,9,13:17)], latitude=-18.66, longitude=-44, stringsAsFactors=FALSE)
}
 
data/Rodriguez2003
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Bark_Stemwood  <-  raw$Bark + raw$Stemwood
  raw$Crown_class[raw$Crown_class==1]  <-  "intermediate"
  raw$Crown_class[raw$Crown_class==1]  <-  "codominant"
  raw$Crown_class[raw$Crown_class==1]  <-  "dominant"
  data   <-  cbind(dataset=studyName, species="Pinus radiata", grouping=paste("Treatment", raw$Treatment, raw$Crown_class, sep="; "), raw[,c(4:8,10,12:ncol(raw))], latitude=-34.2, longitude=-72.93, growingCondition="PM", vegetation="TempF", pft="EG", map=700, mat=13.64, stringsAsFactors=FALSE)
}
 
data/Roeh1997
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species=raw$species, raw[,c(1:7,9)], growingCondition="PU", vegetation="TempF",   stringsAsFactors=FALSE)
}
 
data/Salazar2010
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Stem_biomass  <-  raw$Branch_biomass+raw$Trunk_biomass
  raw$map[raw$Species=="Castanea sativa "]    <-  1590
  raw$map[raw$Species=="Quercus pyrenaica "]  <-  1530
  raw$mat[raw$Species=="Castanea sativa "]    <-  10.8
  raw$mat[raw$Species=="Quercus pyrenaica "]  <-  11.1
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(2:5,7:10)], growingCondition="FW", stringsAsFactors=FALSE)
}
 
data/SantaRegina1999
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Stem_biomass  <-  raw$Branch_biomass+raw$Trunk_biomass
  raw$pft[raw$Species=="Fagus sylvatica"]    <-  "DA"
  raw$pft[raw$Species=="Pinus sylvestris"]   <-  "EG"
  data   <-  cbind(dataset=studyName, species=raw$Species, raw[,c(2:5,7,10:11)], growingCondition="FW", location="Sierra de la Demanda, Spain", vegetation="TempF", latitude=42.33, longitude=4.16, mat=12.4, map=895, stringsAsFactors=FALSE)
}
 
data/Selaya2007
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw        <-  raw[raw$reference=="Selaya et al. (2007) Annals of Botany 99:141-151; Selaya & Anten (2010) Ecology 91: 1102-1113",]
  raw$light  <-  raw$light/55*100
  data   <-  cbind(dataset=studyName, species=raw$Species, grouping=raw$group..7., raw[,c(4:16,18,19,25:ncol(raw))], growingCondition="PU",  latitude=-11, longitude=-66, stringsAsFactors=FALSE)
}
 
data/Selaya2008
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw        <-  raw[raw$reference=="Selaya & Anten (2008) Functional Ecology 22: 30-39",]
  raw$light  <-  raw$light/55*100
  data   <-  cbind(dataset=studyName, species=raw$Species, grouping=raw$group..7., raw[,c(4:16,18,19,25:ncol(raw))], growingCondition="PU",  latitude=-11, longitude=-66, location="Riberalta, Bolivian Amazon", stringsAsFactors=FALSE)
}
 
data/Selaya2008b
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw        <-  raw[raw$reference=="Selaya et al. (2008) Journal of Ecology 96: 1211-1221; Selaya & Anten (2010) Ecology 91:1102-1113",]
  raw$light  <-  raw$light/55*100
  data   <-  cbind(dataset=studyName, species=raw$Species, grouping=raw$group..7., raw[,c(4:16,18,19,25:ncol(raw))], growingCondition="PU",  latitude=-11, longitude=-66, location="Riberalta, Bolivian Amazon", stringsAsFactors=FALSE)
}
 
data/Sillett2010
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
 
data/Stancioiu2005
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$status[raw$crown.class=="i"]   <-  1
  raw$status[raw$crown.class=="s"]   <-  0
  raw$status[raw$crown.class=="d"]   <-  3
  raw$status[raw$crown.class=="cd"]  <-  2  
  data   <-  cbind(dataset=studyName, species="Sequoia sempervirens", raw[,c(2:3, 6, 7, 13:16)], growingCondition="FW",  pft="EA", vegetation="TempF",  map=1300, latitude=39.37278, longitude=-123.6556, location="Jackson Demonstration State Forest, California, USA", stringsAsFactors=FALSE)
}
 
data/Sterck0000
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data   <-  cbind(dataset=studyName, species="????????", raw[,c(4:10)], stringsAsFactors=FALSE)
}
 
data/Sterck2001
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$Sp[raw$Sp=="VA"]  <-  "Vouacapoua americana Aubl."
  raw$Sp[raw$Sp=="DG"]  <-  "Dicorynia guianensis Amshoff."
  data   <-  cbind(dataset=studyName, species=raw$Sp, raw[,c(4:8,10:12,15)], growingCondition="FW", vegetation="TropRF", location="les Nouragues Biological Field Station, French Guiana", latitude=4.08, longitude=-52.66, map=3000, stringsAsFactors=FALSE)
}
 
data/Valladares2000
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$species  <-  gsub("P.", "Psychotria", raw$species)
  data     <-  cbind(dataset=studyName, species=raw$species, grouping=raw$treatment, raw[,c(3:12)], growingCondition="FE", vegetation="TropRF", pft="EA", location="Barro Colorado Island (BCI, Panama)", latitude=9.15, longitude=-79.85, stringsAsFactors=FALSE)
}
 
data/Wang1995
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data     <-  cbind(dataset=studyName, species="Populus tremuloides Michx.", raw[,c(2:8)], growingCondition="FW", vegetation="BorF", pft="DA", location="Dawson Creek, Forest District of northeastern British Columbia, CA", map=450, stringsAsFactors=FALSE)
}
 
data/Wang1996
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data     <-  cbind(dataset=studyName, species="Betula papyrifera Marsh", raw[,c(2:8)], growingCondition="FW", vegetation="BorF", pft="DA", location="British Columbia, CA", map=668, stringsAsFactors=FALSE)
}
 
data/Wang2000
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$m.rc       <-  raw$Lrg..Root+raw$Med..Root
  raw$Stem.Wood  <-  raw$Stem.Wood + raw$Stem.Bark
  
  raw$pft[raw$species=="Abies lasiocarpa"]   <-  "EG" 
  raw$pft[raw$species=="Betula papyrifera"]  <-  "DA"
  
  data       <-  cbind(dataset=studyName, species=raw$species, raw[,c(3:11,14:17)], growingCondition="FW", vegetation="BorF", location="24 km east of Prince George, British Columbia, CA", map=628.3, stringsAsFactors=FALSE)
}
 
data/Wang2011
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  data       <-  cbind(dataset=studyName, species="Pinus sylvestris var. mongolica", raw[,c(2:ncol(raw))], growingCondition="PM", location="Liaoning Sand Stabilization and Afforestation Institute in Zhanggutai, China", pft="EG", latitude=42.72, longitude=122.3667, map=505.9, mat=6, stringsAsFactors=FALSE)
}
 
data/Yamada1996
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$stem.dry.mass..g. <-  raw$stem.dry.mass..g.+ raw$branch.dry.mass..g.
  data       <-  cbind(dataset=studyName, species=raw$Species, raw[,c(4:8,10:13)], growingCondition="FW", vegetation="TropRF", location=raw$site, pft="DA", latitude=0.75, longitude=110.1, map=4265, stringsAsFactors=FALSE)
}
 
data/Yamada2000
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$stem.dry.mass..g. <-  raw$stem.dry.mass..g.+ raw$branch.dry.mass..g.
  data       <-  cbind(dataset=studyName, species=raw$Species, raw[,c(4:8,10:13)], growingCondition="FW", vegetation="TropRF", location=raw$site, pft="DA", latitude=4.12, longitude=114, map=3200, stringsAsFactors=FALSE)
}
 
data/leMaire2011
#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  names(raw)[names(raw)=="map.mm"]  <-  "map"
  raw$reference  <-  "le Maire G, Marsden C, Verhoef W, Ponzoni FJ, Lo Seen D, Bégué A, Stape J-L, Nouvellon Y (2011) Leaf area index estimation with MODIS reflectance time series and model inversion during full rotations of Eucalyptus plantations. Remote Sensing of Environment 115:586–599."
  data      <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Variable.Unit, sep="; "), raw[,c(3,5:19,21:ncol(raw))], stringsAsFactors=FALSE)
}
