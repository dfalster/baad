rm(list=ls())

source('report/report-fun.R')

# Load all data
dat <- loadStudies(reprocess=FALSE)

# single study
printStudyReport(dat, "Aiba2007", reprocess=TRUE)
emailReport(dat, "Aiba2005")

# All reports:
reportPaths <- printAllStudyReports(dat)

# Reprocess one study
tmp <- loadStudy("Gargaglione2010", reprocess= TRUE)
dat <- loadStudies(reprocess=FALSE)

