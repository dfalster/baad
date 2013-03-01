
library(testthat)
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#Remove existing data files
unlink("output/data/*")

#names of all studies
studyNames     <-  getStudyNames()

#import data
data<-lapply(studyNames, importAndCheck, verbose=TRUE)

#count number of records
vec<-0
for(ax in 1:length(data)){
  vec<-vec+dim(data[[ax]])[1]
}
cat("\nNumber of records", vec,"\n")
rm(vec)

#Test single study
#d<-importAndCheck("Salazar2010", verbose=TRUE, browse= TRUE)


