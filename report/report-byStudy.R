rm(list=ls())

source('report/report-fun.R')

# Load all data
dat <- loadStudies(reprocess=TRUE)

# single study
printStudyReport(dat, "Aiba2007", reprocess=FALSE)
printStudyReport(dat, "Lusk2011", reprocess=FALSE)

printStudyReport(dat, "Ishihara0000", reprocess=TRUE)
emailReport(dat, "Gargaglione2010")

# All reports:
reportPaths <- printAllStudyReports(dat)


# Reprocess one study
tmp <- loadStudy("Gargaglione2010", reprocess= TRUE)
dat <- loadStudies(reprocess=FALSE)


data = extractStudy(dat, "Bond-Lamberty2002")$data

