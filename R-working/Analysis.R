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


#make plot of colours and groupnames
plotColours<-function(names, cols, cex=1){
  plot(0, 0, type='n', xlim=c(0,10), ylim=c(0,length(names)+2), ann=F, yaxt="n", xaxt="n")
  text(7, length(names)-1, "colour scheme", cex=2)    
  for(i in 1:length(names)){
    points(0.5,1+i, col=cols[i])
    text(1, 1+i, names[i], col=cols[i], cex=cex, pos=4)  
  }
  cbind(unique(names), cols)
}

#fit sma to 
colourByGroup<-function(data, groupFitName, colourName, YName, XName, log="xy", add=T, col=NA, minNumPoints=6){
  
  if(is.na(col[1])) col <- c("blue2", "goldenrod1", "firebrick2", "chartreuse4", 
                             "deepskyblue1", "darkorange1", "darkorchid3", "darkgrey", 
                             "mediumpurple1", "orangered2", "chocolate", "burlywood3", 
                             "goldenrod4", "darkolivegreen2", "palevioletred3", 
                             "darkseagreen3", "sandybrown", "tan", "gold", "violetred4", 
                             "darkgreen")
  grps<-unique(data[,colourName])
  ngrps<-length(grps)
  
  for(i in 1:ngrps){
    dataNew<-data[data[, colourName]== grps[i],]
    if(min(sum(!is.na(dataNew[,YName])), sum(!is.na(dataNew[,XName]))) >6){
      cat(i, " ", grps[i], " ", length(dataNew[,1]), " || ")    
      #if(grps[i]=="Lusk")  browser() 
      sm<- sma(dataNew[,YName]~dataNew[,XName]*dataNew[,groupFitName], log=log)
      plot(sm, add=add, col=col[i])     
    }
    else{
      cat(i, " ", grps[i], " ", length(dataNew[,1]), "excluded || ")  
    }      
  } 
  #  browser() 
}


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

