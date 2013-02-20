
library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#Remove existing data files
system("rm output/data/*")

#names of all studies
studyNames     <-  getStudyNames()

#import data
cat("\nImport data:\t")
data<-lapply(studyNames, importData)

#count number of records
vec<-0
for(ax in 1:length(data)){
  vec<-vec+dim(data[[ax]])[1]
}
cat("\nNumber of records", vec,"\n")
rm(vec)

cat("\nCheck old versus new data:\t")
out<-lapply(studyNames, compareOldNew)



