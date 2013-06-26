rm(list=ls())

source('report/report-fun.R')
source('report/report-1-email.R')

# Load all data
dat <- loadStudies(reprocess=TRUE)

# single study
printStudyReport(dat, "Aiba2007", reprocess=FALSE)
printStudyReport(dat, "Ishihara0000", reprocess=TRUE)

# All reports:
reportPaths <- printAllStudyReports(dat, reprocess=TRUE)
reportPaths <- mclapply(getStudyNames(), printStudyReport, alldata=dat, reprocess=TRUE)


# Reprocess one study
tmp <- loadStudy("Selaya2007", reprocess= TRUE)
dat <- loadStudies(reprocess=FALSE)

#Email report
emailReport(dat, "Parviainen1999", updateStage=TRUE, print.only=TRUE)
emailReport(dat, "Kantola2004", updateStage=FALSE, print.only=TRUE)
lapply(getStudyNames() ,emailReport, alldata=dat)
emailReport(dat, "Selaya2008")


#batch update - done
processedStudies  <-  read.csv("processed_studies.csv", h=TRUE, stringsAsFactors=FALSE)
chosen.st  <-  processedStudies$study[ processedStudies$update_with_email=="y"]
lapply(chosen.st, function(x)emailReport(dat, x, updateStage=TRUE, print.only=FALSE))




