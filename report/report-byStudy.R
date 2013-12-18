rm(list=ls())

source('report/report-fun.R')
source('report/report-1-email.R')

# Load all data
dat <- loadStudies(reprocess=TRUE)


# Reprocess one study
S <- "Ishihara0000"
tmp <- loadStudy(S, reprocess= TRUE)
dat <- loadStudies(reprocess=FALSE)
printStudyReport(dat, S, reprocess=TRUE)

emailReport(dat, S, updateStage=FALSE)

lapply(list.files(file.path("data",S,"review"), full.names=TRUE), cleanLineEndings)

cleanLineEndings <- function (x){
	txt <- readLines(x)
	writeLines(txt, x)
}

# single study
printStudyReport(dat, "Kantola2004", reprocess=FALSE)

# All reports:
reportPaths <- printAllStudyReports(dat, reprocess=TRUE)
reportPaths <- lapply(c("Ando1988","Ishihara0000","Nishioka1982", "Utsugi0000", "Utsugi2004", "Yoda1978"), printStudyReport, alldata=dat, reprocess=TRUE)


bibfile<- dat$ref$filename[1]
formatBib(bibfile)

# Reprocess one study
tmp <- loadStudy("Sillett2010", reprocess= TRUE)
dat <- loadStudies(reprocess=FALSE)

#Email report
emailReport(dat, "Yamakura1986", updateStage=TRUE, print.only=FALSE)
emailReport(dat, "Myster2009", updateStage=FALSE)
lapply(getStudyNames() ,emailReport, alldata=dat)
emailReport(dat, "Selaya2008", updateStage=FALSE)


emailReport(dat, "Yamakura1986", updateStage=TRUE, print.only=TRUE)

#batch update - done
processedStudies  <-  read.csv("config/processed_studies.csv", h=TRUE, stringsAsFactors=FALSE)
chosen.st  <-  processedStudies$study[processedStudies$update_with_email=="y1"]
lapply(chosen.st, function(x)emailReport(dat, x, updateStage=TRUE, print.only=FALSE))

#batch update - more info needed
chosen.st  <-  processedStudies$study[processedStudies$update_with_email=="y2"]
lapply(chosen.st, function(x)emailReport(dat, x, updateStage=FALSE, print.only=FALSE))

# Send reminder
sendReminder(alldata=dat, "Baltzer2007")



