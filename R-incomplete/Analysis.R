library(stats)
library(smatr)

#Set base dir
base.dir<-"~/Dropbox/Documents/_research/falster-allometry/project/"  
#  base.dir<-"/Users/barneche/Dropbox/Daniel_datasets/" 
setwd(base.dir)

#load variables & functions
dir.cleanData = "data-clean"
dir.rawData = "data-original/5-processed"
Variables<- read.csv(paste(base.dir,"R/variable_definitions.csv",sep=""))

source("R/Biomass-utils.R")

#Make clean data files
#source("R/makeCleanDataFiles.R")

#Make master data file
source("R/makeMasterDataFile.R")

AllData<-read.csv(paste(dir.cleanData,"/AllData.csv",sep=""))
names(AllData)

#Manipulate data
AllData$a.st <-AllData$a.stbh
i<-is.na(AllData$a.stbh)
AllData$a.st[i]=pi*(0.5*AllData$d.st[i])^2

cat("We have data for",  length(AllData$dataset),"individuals from", length(unique(AllData$dataset)), "studies covering",  length(unique(AllData$species)), "species")

cat(unique(as.character(AllData$dataset)), sep=", ")

pairs<-NULL
pairs[[1]]<-c("h.t", "a.lf")
pairs[[2]]<-c("h.t", "m.lf")
pairs[[3]]<-c("h.t", "m.st")
pairs[[4]]<-c("h.t", "m.to")
pairs[[5]]<-c("m.lf", "m.st")
pairs[[6]]<-c("a.st", "a.lf")
pairs[[7]]<-c("h.t", "a.cp")

#group<-AllData$species
group<-AllData$dataset

pdf(file= paste("output/results-dataset.pdf"), onefile=TRUE, paper ="a4r")
smafit<-NULL
for(i in 1:length(pairs)){
  smafit[[i]]<-sma(AllData[,pairs[[i]][2]] ~ AllData[,pairs[[i]][1]]*group, log="xy")
  plot(smafit[[i]], xlab=pairs[[i]][1], ylab=pairs[[i]][2])
}
dev.off()

