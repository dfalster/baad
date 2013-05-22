rm(list=ls())

source('report/report-fun.R')

# Load all data
dat <- loadStudies(reprocess=FALSE)

# All reports:
reportPaths <- printAllStudyReports(dat)


#trial emal
emailReport(dat, "Aiba2005")

printStudyReport(dat, "Aiba2007", reprocess=TRUE)
  

#create dataNew.csv files for authors to fill in
generateAllDataNew(dat, studyNames)

#-- Not touched : will change with new email code??
#for each study, put variable.definition, contactInfo and Reference in the email folder
y  <-  lapply(getStudyNames(), function(x)emailFiles(dat$data, x))

