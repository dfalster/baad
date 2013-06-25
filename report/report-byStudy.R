rm(list=ls())

source('report/report-fun.R')
source('report/report-1-email.R')

# Load all data
dat <- loadStudies(reprocess=TRUE)

# single study
printStudyReport(dat, "Aiba2007", reprocess=FALSE)
printStudyReport(dat, "Ishihara0000", reprocess=TRUE)

# All reports:
reportPaths <- printAllStudyReports(dat)

# Reprocess one study
tmp <- loadStudy("Selaya2007", reprocess= TRUE)
dat <- loadStudies(reprocess=FALSE)

#Email report
emailReport(dat, "Parviainen1999", updateStage=TRUE, print.only=TRUE)
emailReport(dat, "Kantola2004", updateStage=FALSE, print.only=TRUE)
lapply(getStudyNames() ,emailReport, alldata=dat)
emailReport(dat, "Selaya2008")