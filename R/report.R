
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source('R/report-fun.R')

#names of all studies
studyNames     <-  getStudyNames()

#import data
s<-"Aiba2005"
processStudy(s, verbose = TRUE)
d<-addStudies(studyNames, reprocess = FALSE, verbose = FALSE)
makePlotPanel(d$data, s, pdf=FALSE)

#plot of all data
makePlotPanel(d$data, "all", col=niceColors()[as.factor(d$data$dataset)], pdf=TRUE)

tmp<-lapply(unique(d$data$dataset), makePlotPanel, data=d$data, dir="report")

#Reporting
writeEmail<-function(d, fileName=paste("output/Email.txt", sep='')){
  cat(sprintf('%s,', unique(d$contact$email)), file= fileName)
  cat("\n\nDear contributors to the Biomass and Allometry database, (", file= fileName, append= TRUE)
  cat(sprintf('%s,', getContributors(d)$name), file= fileName, append= TRUE)
  cat(")\n\n", file= fileName, append= TRUE)
  cat("We have data for",  length(d$data$dataset),"individuals from", length(unique(d$data$dataset)), "studies covering",  length(unique(d$data$species)), "species.\n\n", file= fileName, append= TRUE)
  cat("The full list of studies included in the study is:\n", file= fileName, append= TRUE)
  cat(sprintf('  %s\n',d$ref[,2]), file= fileName, append= TRUE)
  cat("\n\nThe species included in the study are:\n", file= fileName, append= TRUE)
  cat(sprintf('%s,', sort(unique(as.character(d$data$species)))), file= fileName, append= TRUE)
}

writeEmail(d)


##
writeLines(sprintf('%s,', getContributors(d)$name))

