rm(list=ls())
source('R/packages.R')
source('R/utils-fun.R')
source('R/import-fun.R')
source('R/report-fun.R')

# Load all data
dat <- loadStudies()

# List all study names
studyNames <- getStudyNames()

#create dataNew.csv files for authors to fill in
generateAllDataNew(dat, studyNames)

# Not touched : will change with new email code??
#for each study, put variable.definition, contactInfo and Reference in the email folder
y  <-  lapply(studyNames, function(x)emailFiles(d$data, x))


# Markdown report (HTML)
studyReportMd(dat, "Ilomaki2003")
studyReportMd(dat, "Parviainen1999")

# All reports:
allStudyReport(dat, studyNames)

