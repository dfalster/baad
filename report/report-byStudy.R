rm(list=ls())
source('R/import.R')
source('R/plotting.R')
source('R/formatBib.R')
source('R/email.R')

source('report/report-fun.R')

# Load all data
dat <- loadStudies(reprocess=FALSE)

# Markdown report (HTML)
reportPath<-printStudyReport(dat, "Ilomaki2003")

# All reports:
reportPaths <- printAllStudyReports(dat)

emailReport("Ilomaki2003", reportPath= reportPath, to = c("daniel.falster@mq.edu.au"), from ="daniel.falster@mq.edu.au", cc= "daniel@falsters.net")
  


#create dataNew.csv files for authors to fill in
generateAllDataNew(dat, studyNames)

#-- Not touched : will change with new email code??
#for each study, put variable.definition, contactInfo and Reference in the email folder
y  <-  lapply(getStudyNames(), function(x)emailFiles(dat$data, x))

