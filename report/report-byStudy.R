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
tmp <- loadStudy("Martin1998", reprocess= TRUE)
dat <- loadStudies(reprocess=FALSE)

#Email report
emailReport(dat, "Parviainen1999", updateStage=TRUE, print.only=TRUE)
emailReport(dat, "Kantola2004", updateStage=FALSE, print.only=TRUE)
lapply(getStudyNames() ,emailReport, alldata=dat)
emailReport(dat, "Selaya2008")


emailReport(dat, "Martin1998", updateStage=TRUE, print.only=FALSE)

#batch update - done
processedStudies  <-  read.csv("config/processed_studies.csv", h=TRUE, stringsAsFactors=FALSE)
chosen.st  <-  processedStudies$study[processedStudies$update_with_email=="y1"]
lapply(chosen.st, function(x)emailReport(dat, x, updateStage=TRUE, print.only=FALSE))

#batch update - more info needed
chosen.st  <-  processedStudies$study[processedStudies$update_with_email=="y2"]
lapply(chosen.st, function(x)emailReport(dat, x, updateStage=FALSE, print.only=FALSE))

# Send reminder
sendReminder(alldata=dat, "Baltzer2007")



