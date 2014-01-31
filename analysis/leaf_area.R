source('report/report-fun.R')
source('R/fillDerivedVariables.R')

#names of all studies
dat <- loadStudies(reprocess=FALSE)
data <- fillDerivedVariables(dat$data)

addIsoclines <- function(A= seq(-10,10),b=1,...){
  for(a in A) abline(a,b,lty="dotted",...)
}

myplot <- function(data, xvar,yvar,g,add=FALSE,col=niceColors(1),add11=TRUE,...){
  bivarPlotColorBy(data, xvar, yvar,g,col=make.transparent("grey", 0.4), pch=16,type='p',add=add,...)
  bivarPlotColorBy(data, xvar, yvar,group=g,col=col,lwd=1, type='l', add=TRUE)
 }

xlim <- c(0.005, 120)
ylim <- c(1E-5, 1E3)
f <- myplot(data,"h.t", "a.lf", "species",col=cols[1],xlim=xlim, ylim=ylim, main = "base")
addIsoclines(b=2)


# Most variation among species, little difference between PFT, vegetation type, study

bivarPlotColorBy(data,"h.t", "a.lf", "pft",col=make.transparent(niceColors(), 0.5), pch=16,type='b', legend=TRUE)

bivarPlotColorBy(data,"h.t", "a.lf", "vegetation",col=make.transparent(niceColors(), 0.5), pch=16,type='b', legend=TRUE)

bivarPlotColorBy(data,"h.t", "a.lf", "dataset",col=make.transparent(niceColors(), 0.5), pch=16,type='b', legend=FALSE)

