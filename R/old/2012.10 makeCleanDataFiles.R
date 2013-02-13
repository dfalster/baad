

#TO DO
#Aiba2005 - incorporate aib_all.csv with more data in it
#          - incorporate branch mass separatley?

#Martin 1998 - check claculations accounting for missing heartwood.
#     - check units
#     - a number of variables not yet included        

#Conversion functions - returns units in m, m2, kg
area.cm2<-function(x){x/1E4}  # 100 x 100 = 10^4 cm2/m2
area.mm2<-function(x){x/1E6}  # 1000 x 1000 = 10^6 mm2/m2
mass.g<-function(x){x/1E3}
len.cm<-function(x){x/1E2}
len.mm<-function(x){x/1E3}
convertDBH.mm<-function(x){pi*(0.5*x/1E3)^2}
convertDBH.cm<-function(x){pi*(0.5*x/1E2)^2}
convertDBH.m<-function(x){pi*(0.5*x)^2}

#Aiba 2005--------------------------------------
name<-"Aiba2005"
#load data file
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''))
attach(Raw) #attach data 
#create new data frame with correct names and units
Data<-data.frame(dataset=name, species=paste(Genus, Species), a.lf=area.cm2(total.leaf.area..cm.2.), lf.sz=area.cm2(individual.leaf.area..cm.2.), a.cp=area.cm2(crown.area..cm.2.), h.t = len.cm(height..cm.), h.c = len.cm(crown.depth..cm.), m.lf=mass.g(leaf.mass..g.), m.st=mass.g(trunk.mass..g.+ branch.mass..g.), m.br=mass.g(branch.mass..g.), m.rt=mass.g(root.mass..g.), pft="EA", growingCondition="FW", location="4d2'N, 113d50'E", veg="TropRF", map="2700", mat="26")
#write to file
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw) #detach data
rm(Data, Raw) #remove data

#Baraloto 2006----------------------------------
name<-"Baraloto2006"
#load data file
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''), stringsAsFactors=F)
#change spp names
unique(Raw$SpID)
Raw$SpID[Raw$SpID== 'Gg']= "Goupia glabra";
Raw$SpID[Raw$SpID== 'Jc']= "Jacaranda copaia";
Raw$SpID[Raw$SpID== 'Rs']= "Recordoxylon speciosum";
Raw$SpID[Raw$SpID== 'Dg']= "Dicorynia guianensis";
Raw$SpID[Raw$SpID== 'Ef']= "Eperua falcata";
Raw$SpID[Raw$SpID== 'Eg']= "Eperua grandiflora";
Raw$SpID[Raw$SpID== 'Qr']= "Qualea rosea";
Raw$SpID[Raw$SpID== 'Sr']= "Sextonia rubra";
Raw$SpID[Raw$SpID== 'Vm']= "Virola michelii";
attach(Raw)
#Create new dataframe
Data<-data.frame(dataset=name, species=SpID, a.lf=area.cm2(SF), a.st=convertDBH.mm(Diam), h.t=len.cm(Ht), m.lf=mass.g(Lf), m.st=mass.g(Stem), m.rt=mass.g(Root), lf.ma=SLA, growingCondition="GH", location="5d18'N,52d55'W", veg="TropRF")
#write to file
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw) #detach data
rm(Data, Raw) #remove data

#Bond-Lamberty 2002-----------------------------
name<-"Bond-Lamberty2002"
#load data file
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''), stringsAsFactors=F)
#change spp names
unique(Raw$Species)
Raw$Species[Raw$Species== 'A']= "Populus tremuloides";
Raw$Species[Raw$Species== 'BI']= "Betula papyrifera";
Raw$Species[Raw$Species== 'BS']= "Picea mariana";
Raw$Species[Raw$Species== 'JP']= "Pinus banksiana";
Raw$Species[Raw$Species== 'T']= "Larix laricina";
Raw$Species[Raw$Species== 'W']= "Salix spp";
attach(Raw) #attach data
#create new data frame with correct names and units
Data<-data.frame(dataset=name, species=Species, a.st_DBH=DBH, a.st_0=D0, a.st_D10=D10, h.t=len.cm(Height), m.lf=mass.g(TotFol), m.st=mass.g(TotWood + TotBranch + Stem),  m.sh=mass.g(TotWood), m.br=mass.g(TotBranch), growingCondition="FE", location=paste(Lat, Long), veg="BorF")
#write to file
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw) #detach data
rm(Data, Raw) #remove data

#Duursma 2012-----------------------------------
name<-"Duursma2012"
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''))
#data cleaning
Raw<-subset(Raw, Raw$dataset!="Falster")
#calculate total height
Raw$h_c[Raw$h_c<0]<-0
Raw$h_t<-Raw$h_c+Raw$h_lf
#remove negative heights
Raw<-subset(Raw, Raw$h_t>0)
attach(Raw)
Data<-data.frame(dataset=name, group=dataset, species=species, a.lf=a_lf, lf.sz=lfSz, a.st=a_st, a.cp=a_cp, a.cs=a_cs, h.t=h_t, h.c=h_c, h.lf=h_lf)
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw)
rm(Data, Raw)

#Martin 1998-----------------------------------
name<-"Martin1998"
#load datafile
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''), fill=T)
attach(Raw)
#create new data frame with correct names and units
Data<-data.frame(dataset=name, species=spp, age=age, a.lf=a_lf, a.ss=A, a.st=convertDBH.m(D), h.t=H, m.t=m_tot, m.st=NA, m.lf=m_lf, m.ss=m_sa, m.sh=m_ht, lma = LMA, veg="TempF")
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw)
rm(Data, Raw)

             
#Lusk------------------------------------------
name<-"Lusk"
#load datafile
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''))
attach(Raw)
#Create new data frame with correct names and units
Data<-data.frame(dataset=name, family=Family, species=Species, a.lf=a.lf, lf.sz=lf.sz, a.st=a.st, a.cp=a.cp, a.cs=a.cs, h.t=h.t, h.c=h.c, m.lf=m.lf, m.st=m.st, m.rt=m.rt, veg=Forest.type)
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw)
rm(Data, Raw)

#Mokany 2003-----------------------------------
name<-"Mokany2003"
#load datafile
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''), skip=2, fill=T)
attach(Raw)
#create new data frame with correct names and units
Data<-data.frame(dataset=name, family=Family, species=Species, age=Age, a.lf=a.lf, a.ss=a.ss, a.sh=a.sh, a.st=a.st, h.lf=h.lf, h.t=h.t, m.lf=m.lf, pft=pft, growingCondition=growingCondition, status=status, location=location, latitude=latitude, longitude=longitude, veg="TempF", map=map)
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw)
rm(Data, Raw)

#Rodrigez2003---------------------------------------------
name<-"Rodriguez2003"
#load datafile
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''))
attach(Raw)
#create new data frame with correct names and units
Data<-data.frame(dataset=name, species="Pinus radiata", a.lf=Leaf_area, a.ss=Sapwood_area, a.st=Dbh, h.t=Total_height, m.lf=Needles, m.st=paste(Stemwood, Bark), m.sb=Bark, m.br=Branches, m.rf=Fine_roots, m.rc=Coarse_roots, lf.ma1=SLA_Lower_third, lf.ma2=SLA_Middle_Third, lf.ma3=SLA_Upper_third, pft="EG", growingCondition="PM", status=Crown_class, location="34d9'S-34d15'S, 72d53'W-72d59'W", veg="TempF", map="700")
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw)
rm(Data, Raw)

#SantaRegina1999-----------------------------------
name<-"SantaRegina1999"
#load datafile
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''), skip=1)
attach(Raw)
#create new data frame with correct names and units
Data<-data.frame(dataset=name, species=Species, a.st=DBH, h.t=Height, m.lf=Leaf_biomass, m.st=Trunk_biomass, m.br=Branch_biomass, location="42d20'N, 4d10'E", veg="TempF", map="895", mat="12.4")
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw)
rm(Data, Raw)

#Salazar2010-----------------------------------
name<-"Salazar2010"
#load datafile
Raw<-read.csv(paste(dir.rawData,"/",name,"/data.csv", sep=''))
attach(Raw)
#create new data frame with correct names and units
Data<-data.frame(dataset=name, species=Species, a.st=DBH, h.t=Height, m.lf=Leaf_biomass, m.st=Trunk_biomass, m.br=Branch_biomass, veg="TempF")
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw)
rm(Data, Raw)

#Valladares2000-------------------------------------
name<-"Valladares2000"
#load datafile
Raw<-read.csv(paste(dir.rawData,"/",name,"/psychotria.csv", sep=''))
attach(Raw)
#Create new data frame with correct names and units
Data<-data.frame(dataset=name, species=species, a.lf=a.lf, lf.sz=lf.sz, a.cs=a.cs, h.t=h.t, h.c=h.c, m.lf=m.lf)
write.csv(Data, paste(dir.cleanData,"/",name,".csv", sep=''), row.names=FALSE)
detach(Raw)
rm(Data, Raw)








