rm(list=ls())
source('R/import.R')
# source('R/packages.R')

#get study names
studies  <-  getStudyNames()

#prepare new files for pre-import?
#newS        <-  Studies[59]
#makeDataImport(newS)
#setUpFiles(newS)

#change variable names?
var.from  <-  c("a.baba","a.babh","a.babc","lf.sz","lf.ma","d.st","d.ss","d.sb","d.sh")
var.to    <-  c("a.sbba","a.sbbh","a.sbbc","a.ilf","ma.ilf","r.st","r.ss","r.sb","r.sh")
for(i in 1:length(var.from)){
  lapply(studies, function(x){changeVars(study=x, from=var.from[i], to=var.to[i])})
  changeVarCsv(filename="variableDefinitions", column="Variable", from=var.from[i], to=var.to[i], path="config")
}
#change var.def


#process all studies
d <- loadStudies(reprocess=TRUE)
