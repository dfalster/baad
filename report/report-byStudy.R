rm(list=ls())

source('report/report-fun.R')

# Load all data
dat <- loadStudies(reprocess=FALSE)

# All reports:
reportPaths <- printAllStudyReports(dat)


#trial emal
reportPath<-printStudyReport(dat, "Ilomaki2003")
emailReport(dat, "Ilomaki2003", reportPath= reportPath)

, to = c("daniel.falster@mq.edu.au"), from ="daniel.falster@mq.edu.au", cc= "daniel@falsters.net")
  


#create dataNew.csv files for authors to fill in
generateAllDataNew(dat, studyNames)

#-- Not touched : will change with new email code??
#for each study, put variable.definition, contactInfo and Reference in the email folder
y  <-  lapply(getStudyNames(), function(x)emailFiles(dat$data, x))

