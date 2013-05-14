rm(list=ls())
source('R/packages.R')
source('R/import-fun.R')
source('report/report-fun.R')

# Load all data
dat <- loadStudies(reprocess=FALSE)

# Markdown report (HTML)
studyReportMd(dat, "Ilomaki2003")
studyReportMd(dat, "Parviainen1999")

# All reports:
allStudyReport(dat)



#create dataNew.csv files for authors to fill in
generateAllDataNew(dat, studyNames)

#-- Not touched : will change with new email code??
#for each study, put variable.definition, contactInfo and Reference in the email folder
y  <-  lapply(studyNames, function(x)emailFiles(d$data, x))
