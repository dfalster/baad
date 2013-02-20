rm(list=ls())
source("R/Biomass-fun.R")
var.match  <-  read.csv("R/variable_match.csv",h=T,stringsAsFactors=F)
head(var.match)
split.match  <-  function(x){
  for(z in unique(var.match$reference)){
    dat  <-  var.match[var.match$reference==z,]
    write.csv(dat[,-1], paste(dir.rawData,"/",z,"/","variable.match.csv",sep=""), row.names=FALSE)
  }
}
studyNames<-getStudyNames()
split.match(studyNames)
