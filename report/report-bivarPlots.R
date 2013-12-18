rm(list=ls())

source('report/report-fun.R')

#names of all studies
data <- loadStudies(reprocess=FALSE)

comparePlots(data$data)
