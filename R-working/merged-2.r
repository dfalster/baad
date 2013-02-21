 
#data/Aiba2005
pft="EA", growingCondition="FW", longitude=5.104833, latitude=114.605,vegetation="TropRF", map=2700, mat=26, light="closed[average 6%]", location="Lambir Hills National Park, Sarawak, Malaysia"

#data/Aiba2007
raw$total.stem.mass..g.  <-raw$branch.mass...stem.mass..g.
raw$species=paste(raw$genus, raw$species), growingCondition="FW", vegetation="TropRF", pft="EA", location="Lambir Hills National Park, Sarawak, Malaysia", latitude=4.03, longitude=113.83, map=2700, mat=26    
 
#data/Baltzer2007
raw$species[raw$species=="AR"]  <-  "Acer rubrum"
raw$species[raw$species=="AS"]  <-  "Acer saccharum"
raw$species[raw$species=="BA"]  <-  "Betula alleghaniensis"
raw$species[raw$species=="FA"]  <-  "Fraxinus americana"
raw$species[raw$species=="QR"]  <-  "Quercus rubra"
raw$species[raw$species=="UA"]  <-  "Ulmus americana"
raw$species[raw$species=="BP"]  <-  "Betula papyrifera"
  names(raw)[names(raw) == "Plant.functional.type"]    <-  "pft"
  names(raw)[names(raw) == "Growing.condition"]        <-  "growingCondition"
raw$species=raw$species, latitude=43.66146, longitude=-79.40006    
 
#data/Baraloto2006
raw$species=raw$SpID, raw$grouping=paste("Soil(",raw$Soil,"); ", "H2O(", raw$H2O, "); ", "P(", raw$P, ")", sep=""), growingCondition="GH", longitude=-52.65034, latidude=5.159944, vegetation="TropRF", location="INRA, Kourou, French Guiana"
 
#data/Bond-Lamberty2002
raw$Species[raw$Species=='A']   <-  "Populus tremuloides"
raw$Species[raw$Species=='BI']  <-  "Betula papyrifera"
raw$Species[raw$Species=='BS']  <-  "Picea mariana"
raw$Species[raw$Species=='JP']  <-  "Pinus banksiana"
raw$Species[raw$Species=='T']   <-  "Larix laricina"
raw$Species[raw$Species=='W']   <-  "Salix spp"
    
raw$grouping=paste(raw$Site, raw$HarvestYear, raw$Edaphic, sep="; "),  raw$species=raw$Species, age=raw$HarvestYear-raw$BurnYear, stemMass=raw$TotBranch+raw$Stem, 

longitude=raw$longitude, latitude=raw$latitude, growingCondition="FW", 
vegetation="BorF", location="Near Thompson and Leaf Rapids, Manitoba, Canada", 
 
#data/Coll2008
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
  
raw2$species=raw2$species,  longitude=-79.05222, latitude=9.325, growingCondition="FE", vegetation="TropRF", location="Sardinilla, Buena Vista region, Panama"
 
#data/Delagrange2004
raw$total.stem.mass..g.  <-raw$branch.mass...stem.mass..g.
raw$species=raw$Species, raw$grouping=paste(raw$Group, "; Last perturbation = ", raw$Last.perturbation, sep=""),    
 
#data/Domec2012
#TODO: check reference
raw$species=raw$Species, 
 
#data/Epron2012
raw$a.babh <-raw$a.st - raw$a.st.1
  names(raw)[names(raw)=="group"]  <-  "grouping"
raw$species=raw$species, raw$grouping=paste(raw$Variable, raw$contributor, raw$Nutrition, sep="; ")
 
#data/Harja2012
    
#TODO: not finsihed?
    
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
raw$species=raw$Species, raw$grouping=paste(paste("Isolation_", raw$Isolated, sep=""), paste("Area Density_", raw$Dense, sep=""), raw$sp_measure_envir, sep="; "),  growingCondition="FW", vegetation="TropRF"
 
#data/Kenzo2009
raw$n.lf.per  <-  (raw$n.lf.per/100) * raw$lf.ma.g.m2 # this transforms it from percentage (/unit mass) to /unit area --> final unit g/m2
#TODO: check reference
raw$species=raw$species, raw$grouping=paste(raw$group, raw$location, raw$contributor, sep="; ")    
 
#data/Kenzo2009b
raw$species=raw$species, raw$grouping=paste(raw$location, raw$contributor, sep="; ")  
 
#data/Kohyama1987
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
raw$leaf.mass  <-raw$Wtl.g + raw$Wbl.g
raw$m.st       <-raw$Wts.g + raw$Wbs.g
raw$species=raw$SpecCode, latitude=30.31667, longitude=130.4333, location="Ohkou River, Yakushima Island, Kyushu, Japan"
 
#data/Kohyama1990
raw$SpecCode[raw$SpecCode=='Swinto,']  <-  "Swintonia schwenkii"
raw$SpecCode[raw$SpecCode=='Shorea,']  <-  "Shorea sumatrana"
raw$SpecCode[raw$SpecCode=='Nephel,']  <-  "Nephelium juglandifolium"
raw$SpecCode[raw$SpecCode=='Hopeam,']  <-  "Hopea dryobalanoides"
raw$SpecCode[raw$SpecCode=='Mastix,']  <-  "Mastixia trichotoma"
raw$SpecCode[raw$SpecCode=='Phylla,']  <-  "Cleistanthus glandulosus"
raw$SpecCode[raw$SpecCode=='Grewia,']  <-  "Grewia florida"
raw$SpecCode[raw$SpecCode=='Gonyst,']  <-  "Gonystylus forbesii"
raw$SpecCode[raw$SpecCode=='Diosum,']  <-  "Diospyrus sumatrana"
raw$species=raw$SpecCode, raw$grouping=paste(raw$Year,raw$X., sep="; "),
latitude=-0.9166667, longitude=100.5, map=4760, growingCondition="FW", vegetation="TropRF", location="Ulu Gadut valley, Padang, Sumatra, Indonesia"
 
#data/Kohyama1994
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
raw$species=raw$SpecCode, latitude=30, longitude=130, growingCondition="FW", vegetation="TempRf", location="Yakushima Island, Kyushu, Japan"
 
#data/Lusk0000a
raw$species=raw$Species
growingCondition="GH",  pft="EA", location="New Zealand"    
 
#data/Lusk0000b
raw$species=raw$Species, 
growingCondition="GH", pft="EA", location="New Zealand"    
 
#data/Lusk2002
raw$species=raw$Species, 
growingCondition="FW",  vegetation="TempRf", pft="EA", location="Parque Nacional Puyehue, Chile", latitude=-40.65, longitude=-72.18, map=3500    
 
#data/Lusk2004
raw$species=raw$Species,
growingCondition="FW", vegetation="TempRf", pft="EA", location="Parque Nacional Puyehue, Chile", latitude=-40.65, longitude=-72.18, map=3500    
 
#data/Lusk2011
raw$species=raw$Species,
growingCondition="FW",  vegetation="TempRf", location="Parque Nacional Puyehue, Chile", latitude=-40.65, longitude=-72.18, map=3500    
 
#data/Lusk2012
raw$pft    <-  "EA"
raw$pft[raw$Species=="Podocarpus nubigena"]          <-  "EG"
raw$pft[raw$Species=="Podocarpus salignus"]          <-  "EG"
raw$pft[raw$Species=="Saxegothaea conspicua"]        <-  "EG"
raw$pft[raw$Species=="Araucaria araucana"]           <-  "EG"
raw$pft[raw$Species=="Agathis australis"]            <-  "EG"
raw$pft[raw$Species=="Phyllocladus trichomanoides"]  <-  "EG"
species=raw$Species, 
growingCondition="FW",  vegetation="TempRf", location="Parque Nacional Puyehue, Chile", latitude=-40.65, longitude=-72.18, map=3500    
 
#data/Martin1998
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
raw$species=raw$spp, raw$grouping=paste("Filter = ", raw$Filter, sep=""), latitude=35, longitude=-83, map=2035, vegetation="TempRf", growingCondition="FW", pft="DA"    
 
#data/McCulloh2010
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
  
raw$species=raw$species, raw$grouping=paste(raw$wood.type, raw$collection.site, raw$sample, sep="; "),  growingCondition="FW"    
 
#data/Mokany2003
raw$species=raw$Species
 
#data/Mori1991
  raw[raw=="No data"] <-  NA
raw$species="Chamaecyparis obtusa", vegetation="TempF", growingCondition="PU"    
 
#data/Myster2009
raw$species=raw$species,  latitude=36.78333, longitude=-96.41667, map=820, vegetation="TempF", growingCondition="PM"    
 
#data/Nouvellon2010
raw$species=raw$species   
 
#data/O'Grady2000
raw$SPECIES[raw$SPECIES=="E.tet."]    <-  "Eucalyptus tetrodonta"
raw$SPECIES[raw$SPECIES=="E.min."]    <-  "Eucalyptus miniata"
raw$SPECIES[raw$SPECIES=="T.ferd."]   <-  "Terminalia ferdinandiana"
raw$SPECIES[raw$SPECIES=="E.min"]     <-  "Eucalyptus miniata"
raw$SPECIES[raw$SPECIES=="E.chlor."]  <-  "Erythrophloem chlorostachys"
raw$SPECIES[raw$SPECIES=="E.clav."]   <-  "Eucalyptus clavigera"
raw$species=raw$SPECIES, raw$grouping=paste("Site = ", raw$SITE, sep=""), latitude=-12.5, longitude=130.75, growingCondition="FW", pft="EA", vegetation="Sav", location="Howard Springs, NT, Australia", map=1700    
 
#data/O'Grady2006
raw$Leaf.area  <-raw$X
raw$stem       <-raw$stem+raw$branch
raw$m.rf       <-raw$X5.Oct + raw$Oct.15
raw$m.rc       <-raw$X15...20 + raw$X20....stump
raw$species="Eucalyptus globulus", raw$grouping=paste("Harvested on ", raw$Harvested, "; Plot = ", raw$plot, "; Treatment = ", raw$treatment, "; seedling = ", raw$seedling, sep=""), latitude=-42.82, longitude=147.51, growingCondition="PM", pft="EA", location="Pittwater plantation, TAS, Australia", map=500    
 
#data/O'Hara0000
raw$species="Sequoiadendron giganteum"

#data/O'Hara1995
raw$species=raw$species, raw$grouping=raw$site,  vegetation="TempF", growingCondition="FW"    
 
#data/Osada0000
  raw        <-  raw[raw$Source != "Osada et al. (2003) Forest Ecology and Management" & raw$Source != "Osada (2005) Canadian Journal of Botany", ]
raw$species=raw$species, raw$grouping=paste(raw$Source, raw$Tree.No., sep="; ")
 
#data/Osada2003
  raw        <-  raw[raw$Source == "Osada et al. (2003) Forest Ecology and Management", ]
raw$species=raw$species, raw$grouping=paste(raw$Source, raw$Tree.No., sep="; ")
 
#data/Osada2005
  raw        <-  raw[raw$Source == "Osada (2005) Canadian Journal of Botany", ]
raw$species=raw$species, raw$grouping=paste(raw$Source, raw$Tree.No., sep="; ")
 
#data/Osunkoya2007
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
raw$species=raw$species, raw$grouping=paste(raw$Tree_no, raw$growth_form., sep="; ")
latitude=4.5, longitude=115.1667, map=5080, mat=30, growingCondition="FW", vegetation="TropRF", pft="EA"    
 
#data/Petritan2009
raw$species=raw$Species, 
latitude=51.57944, longitude=10.03639, map=780, mat=7.8, growingCondition="FW", vegetation="TempF", pft="EA / DA"    
 
#data/Ribeiro2011
  names(raw)[3]         <-  "family"
  names(raw)[15:17]     <-  c("location","map", "mat")
  names(raw)[13]        <-  "vegetation"
  names(raw)[14]        <-  "growingCondition"  
raw$vegetation        <-  "TropSF (Savannah like)"
raw$growingCondition  <-  "FW"
raw$species=raw$Species, latitude=-18.66, longitude=-44    
 
#data/Rodriguez2003
raw$Bark_Stemwood  <-raw$Bark + raw$Stemwood
raw$Crown_class[raw$Crown_class==1]  <-  "intermediate"
raw$Crown_class[raw$Crown_class==1]  <-  "codominant"
raw$Crown_class[raw$Crown_class==1]  <-  "dominant"
raw$species="Pinus radiata", raw$grouping=paste("Treatment", raw$Treatment, raw$Crown_class, sep="; "),
latitude=-34.2, longitude=-72.93, growingCondition="PM", vegetation="TempF", pft="EG", map=700, mat=13.64    
 
#data/Roeh1997
raw$species=raw$species, growingCondition="PU", vegetation="TempF",   stringsAsFactors=FALSE)
}
 
#data/Salazar2010
raw$Stem_biomass  <-raw$Branch_biomass+raw$Trunk_biomass
raw$map[raw$Species=="Castanea sativa "]    <-  1590
raw$map[raw$Species=="Quercus pyrenaica "]  <-  1530
raw$mat[raw$Species=="Castanea sativa "]    <-  10.8
raw$mat[raw$Species=="Quercus pyrenaica "]  <-  11.1
raw$species=raw$Species, growingCondition="FW"    
 
#data/SantaRegina1999
raw$Stem_biomass  <-raw$Branch_biomass+raw$Trunk_biomass
raw$pft[raw$Species=="Fagus sylvatica"]    <-  "DA"
raw$pft[raw$Species=="Pinus sylvestris"]   <-  "EG"
raw$species=raw$Species,  growingCondition="FW", location="Sierra de la Demanda, Spain", vegetation="TempF", latitude=42.33, longitude=4.16, mat=12.4, map=895    
 
#data/Selaya2007
  raw        <-  raw[raw$reference=="Selaya et al. (2007) Annals of Botany 99:141-151; Selaya & Anten (2010) Ecology 91: 1102-1113",]
raw$light  <-raw$light/55*100
raw$species=raw$Species, raw$grouping=raw$group..7., growingCondition="PU",  latitude=-11, longitude=-66    
 
#data/Selaya2008
  raw        <-  raw[raw$reference=="Selaya & Anten (2008) Functional Ecology 22: 30-39",]
raw$light  <-raw$light/55*100
raw$species=raw$Species, raw$grouping=raw$group..7., 
growingCondition="PU",  latitude=-11, longitude=-66, location="Riberalta, Bolivian Amazon"    
 
#data/Selaya2008b
  raw        <-  raw[raw$reference=="Selaya et al. (2008) Journal of Ecology 96: 1211-1221; Selaya & Anten (2010) Ecology 91:1102-1113",]
raw$light  <-raw$light/55*100
raw$species=raw$Species, raw$grouping=raw$group..7., 
growingCondition="PU",  latitude=-11, longitude=-66, location="Riberalta, Bolivian Amazon"    
 
#data/Sillett2010
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
raw$species=raw$Tree, growingCondition="FW",  pft="EA", vegetation="TempF"    
 
#data/Stancioiu2005
raw$status[raw$crown.class=="i"]   <-  1
raw$status[raw$crown.class=="s"]   <-  0
raw$status[raw$crown.class=="d"]   <-  3
raw$status[raw$crown.class=="cd"]  <-  2  
raw$species="Sequoia sempervirens", growingCondition="FW",  pft="EA", vegetation="TempF",  map=1300, latitude=39.37278, longitude=-123.6556, location="Jackson Demonstration State Forest, California, USA"    
 
#data/Sterck0000
raw$species="????????"    
 
#data/Sterck2001
raw$Sp[raw$Sp=="VA"]  <-  "Vouacapoua americana Aubl."
raw$Sp[raw$Sp=="DG"]  <-  "Dicorynia guianensis Amshoff."
raw$species=raw$Sp, growingCondition="FW", vegetation="TropRF", location="les Nouragues Biological Field Station, French Guiana", latitude=4.08, longitude=-52.66, map=3000    
 
#data/Valladares2000
raw$species  <-  gsub("P.", "Psychotria", raw$species)
raw$species=raw$species, raw$grouping=raw$treatment,  growingCondition="FE", vegetation="TropRF", pft="EA", location="Barro Colorado Island (BCI, Panama)", latitude=9.15, longitude=-79.85    
 
#data/Wang1995
species="Populus tremuloides Michx.", growingCondition="FW", vegetation="BorF", pft="DA", location="Dawson Creek, Forest District of northeastern British Columbia, CA", map=450    
 
#data/Wang1996
species="Betula papyrifera Marsh", growingCondition="FW", vegetation="BorF", pft="DA", location="British Columbia, CA", map=668    
 
#data/Wang2000
raw$m.rc       <-raw$Lrg..Root+raw$Med..Root
raw$Stem.Wood  <-raw$Stem.Wood + raw$Stem.Bark
  
raw$pft[raw$species=="Abies lasiocarpa"]   <-  "EG" 
raw$pft[raw$species=="Betula papyrifera"]  <-  "DA"
  
raw$species=raw$species  
growingCondition="FW", vegetation="BorF", location="24 km east of Prince George, British Columbia, CA", map=628.3    
 
#data/Wang2011
raw$species="Pinus sylvestris var. mongolica", growingCondition="PM", location="Liaoning Sand Stabilization and Afforestation Institute in Zhanggutai, China", pft="EG", latitude=42.72, longitude=122.3667, map=505.9, mat=6    
 
#data/Yamada1996
raw$stem.dry.mass..g. <-raw$stem.dry.mass..g.+ raw$branch.dry.mass..g.
raw$species=raw$Species, growingCondition="FW", vegetation="TropRF", location=raw$site, pft="DA", latitude=0.75, longitude=110.1, map=4265    
 
#data/Yamada2000
raw$stem.dry.mass..g. <-raw$stem.dry.mass..g.+ raw$branch.dry.mass..g.
raw$species=raw$Species,  growingCondition="FW", vegetation="TropRF", location=raw$site, pft="DA", latitude=4.12, longitude=114, map=3200    
 
#data/leMaire2011
  names(raw)[names(raw)=="map.mm"]  <-  "map"
raw$species=raw$species, raw$grouping=paste(raw$Variable.Unit, sep="; ")

