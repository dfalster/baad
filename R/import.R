library(testthat)
source('R/Biomass-fun.R')
source('R/import-fun.R')

#Remove existing data files
system("rm output/data/*")

#names of all studies
studyNames     <-  getStudyNames()

#read in files
new<-lapply(studyNames, loadDataOrig)

#convert units and variable names
data<-lapply(new,convertDataOrig)

#print to file
tmp<-lapply(data, writeDataOrig)

#check lengths
expect_that(length(studyNames), equals(length(new)))
expect_that(length(studyNames), equals(length(data)))

#check the final size
vec<-0
for(ax in 1:length(new)){
	vec<-vec+dim(new[[ax]])[1]
}
cat(vec, " records")
rm(vec, new, tmp)


loadStudyData("Myster2009")