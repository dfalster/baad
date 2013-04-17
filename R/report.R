
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source('R/report-fun.R')
source('R/packages.R')

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

#create dataNew.csv files for authors to fill in
z  <-  lapply(studyNames, function(x){generateDataNew(d$data, x)})

#for each study, put variable.definition, contactInfo and Reference in the email folder
y  <-  lapply(studyNames, function(x){emailFiles(d$data, x)})

## NEW: markdown report.
# Need package 'knitr' installed (added to packages.R; RAD)
studyReportMd(d, "Ishihara0000")
studyReportMd(d, "Aiba2007")
studyReportMd(d, "Bond-Lamberty2002")

l  <-  lapply(studyNames, function(x){studyReportMd(d, x)})

##
writeLines(sprintf('%s,', getContributors(d)$name))

