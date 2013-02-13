
source("R/test-import-fun.R")
source('R/Biomass-fun.R')

#remove old files
system("rm output/data/*")
studyNames <-getStudyNames()

source('R/import.R')

cat("Check old versus new data")
out<-lapply(studyNames, compareOldNew)


