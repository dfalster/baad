rm(list=ls())

#library("devtools")
#install_github("dataMashR","dfalster")

source('report/report-fun.R')
source('report/report-1-email.R')

# Load all data
dat <- loadStudies(reprocess=TRUE)

# single study
printStudyReport(dat, "Ishihara0000", reprocess=TRUE)
printStudyReport(dat, "Kantola2004", reprocess=TRUE)

# All reports:
reportPaths <- printAllStudyReports(dat, reprocess=TRUE)
reportPaths <- lapply(c("Baraloto2006", "Ishihara0000", "Kantola2004", "King1996", "Utsugi0000", "Utsugi2004", "Yoda1978"), printStudyReport, alldata=dat, reprocess=TRUE)


bibfile<- dat$ref$filename[1]
formatBib(bibfile)

# Reprocess one study
tmp <- loadStudy("Sillett2010", reprocess= TRUE)
dat <- loadStudies(reprocess=FALSE)

#Email report
emailReport(dat, "Myster2006", updateStage=TRUE, print.only=TRUE)
emailReport(dat, "Baraloto2006", updateStage=TRUE)
lapply(getStudyNames() ,emailReport, alldata=dat)
emailReport(dat, "Selaya2008")


emailReport(dat, "Yamakura1986", updateStage=TRUE, print.only=FALSE)

#batch update - done
processedStudies  <-  read.csv("config/processed_studies.csv", h=TRUE, stringsAsFactors=FALSE)
chosen.st  <-  processedStudies$study[processedStudies$update_with_email=="y1"]
lapply(chosen.st, function(x)emailReport(dat, x, updateStage=TRUE, print.only=FALSE))

#batch update - more info needed
chosen.st  <-  processedStudies$study[processedStudies$update_with_email=="y2"]
lapply(chosen.st, function(x)emailReport(dat, x, updateStage=FALSE, print.only=FALSE))

# Send reminder
sendReminder(alldata=dat, "Baltzer2007")



