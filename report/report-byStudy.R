rm(list=ls())
source('R/import.R')
source('report/report-fun.R')
source('R/plotting.R')
source('R/formatBib.R')

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
