
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source('R/report-fun.R')

#names of all studies
studyNames     <-  getStudyNames()

#import data
d<-addStudies(studyNames, reprocess = FALSE, verbose = FALSE)

#plots for all data
makePlotPanel(d$data, "all", col=niceColors()[as.factor(d$data$dataset)], pdf=TRUE)

#plots for each study
makePlotPanel(d$data, "Ishihara0000", pdf=FALSE) #one study, print to screen
tmp<-lapply(unique(d$data$dataset), makePlotPanel, data=d$data, dir="report")  #all, print to file

#maps for each study
makeMapPlot(data=d$data, study="Aiba2005", pdf=TRUE) #one study, print to screen
tmp2<-lapply(unique(d$data$dataset), makeMapPlot, data=d$data, dir="report", pdf=TRUE)  #all, print to file
#print report fo study
studyReport(d, "Ishihara0000")

writeEmail(d)


##
writeLines(sprintf('%s,', getContributors(d)$name))

