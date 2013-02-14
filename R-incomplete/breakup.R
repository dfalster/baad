


source('R/Biomass-fun.R')
source('R/import-fun.R')

#Remove existing data files
system("rm output/data/*")

#names of all studies
studyNames     <-  getStudyNames()[1]

#read in files
new<-lapply(studyNames, loadDataOrig)

#convert units and variable names
data<-lapply(new,convertDataOrig)

#print to file
tmp<-lapply(data, writeDataOrig)


#read in files
new<-lapply(studyNames, loadDataOrig)

breakUpData<-function(studyName){
  
  
}
  

#Check what is in "grouping variable
printGroup<-function(Data){
  cat(Data$dataset[1],"\n")
  cat(unique(Data$grouping))
  cat("\n")
}

tmp<-lapply(data, printGroup)



