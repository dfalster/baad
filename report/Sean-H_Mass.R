
rm(list=ls())
source('R/import.R')
source('report/report-fun.R')

#names of all studies
studyNames     <-  getStudyNames()

#import data
d<-addStudies(studyNames, reprocess = FALSE, verbose = FALSE)

#plot
sm<-sma(d$data$m.st~d$data$h.t*d$data$species, log="xy")
plot(sm)

#fit for height < 1
i<-d$data$h.t <1
sm<-sma(d$data$m.to[i]~d$data$h.t[i], log="xy", method = "OLS")
plot(sm)
sm$groupsummary

