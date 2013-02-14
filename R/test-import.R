
library(testthat)
source('R/Biomass-fun.R')
source('R/import-fun.R')
source("R/test-import-fun.R")

#Remove existing data files
system("rm output/data/*")

#names of all studies
studyNames     <-  getStudyNames()

#import data
data<-lapply(studyNames, importData)

#ccount number of records
vec<-0
for(ax in 1:length(data)){
  vec<-vec+dim(data[[ax]])[1]
}
cat(vec, " records")
rm(vec)

cat("Check old versus new data")
out<-lapply(studyNames, compareOldNew)

