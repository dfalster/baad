rm(list=ls())
source('R/import.R')

#change variable names?
var.from  <-  c("a.baba","a.babh","a.babc","lf.sz","lf.ma","d.st","d.ss","d.sb","d.sh")
var.to    <-  c("a.sbba","a.sbbh","a.sbbc","a.ilf","ma.ilf","r.st","r.ss","r.sb","r.sh")

for(i in 1:length(var.from))
  changeVars (from=var.from[i], to=var.to[i])

changeVarsInFolder("Epron2011", from=var.from[i], to=var.to[i])

#process all studies
d <- loadStudies(reprocess=TRUE)
