rm(list=ls())
source('R/import.R')


if("dataMashR" %in% .packages())
  library(dataMashR)
else {
  library(devtools)
  install_github("dataMashR","dfalster")
  library(dataMashR)
}
  


#change variable names?
var.from  <-  c("a.baba","a.babh","a.babc","lf.sz","lf.ma","d.st","d.ss","d.sb","d.sh")
var.to    <-  c("a.sbba","a.sbbh","a.sbbc","a.ilf","ma.ilf","r.st","r.ss","r.sb","r.sh")

for(i in 1:length(var.from))
  changeVars (from=var.from[i], to=var.to[i])

changeVarsInFolder("Epron2011", from=var.from[i], to=var.to[i])

#process all studies
d <- loadStudies(reprocess=TRUE)
