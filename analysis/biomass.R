source('report/report-fun.R')
source('R/fillDerivedVariables.R')

#names of all studies
dat <- loadStudies(reprocess=FALSE)
data <- fillDerivedVariables(dat$data)


myplot <- function(data, xvar,yvar,g,add=FALSE,col=niceColors(1),add11=TRUE,...){
  bivarPlotColorBy(data, xvar, yvar,g,col=make.transparent("grey", 0.4), pch=16,type='p',add=add,...)
  bivarPlotColorBy(data, xvar, yvar,group=g,col=col,lwd=1, type='l', add=TRUE)
 }


myfigure <- function(){


par(mfrow=c(2,5), oma = c(4,4,4,4))
var <- "species"
xlim <- c(1E-2, 100)
ylim <- c(1E-7, 1E4)

cols <- niceColors(5)

f <- list()
f[[1]] <- myplot(data,"h.t", "m.lf", var,col=cols[1],xlim=xlim, ylim=ylim)
addIsoclines(b=2)
f[[2]] <- myplot(data,"h.t", "m.st", var,col=cols[2], xlim=xlim, ylim=ylim)
addIsoclines(b=2)
f[[3]] <- myplot(data,"h.t", "m.so", var,col=cols[3],xlim=xlim, ylim=ylim)
addIsoclines(b=2)
f[[4]] <- myplot(data,"h.t", "m.rt", var,col=cols[3],xlim=xlim, ylim=ylim)
addIsoclines(b=2)
f[[5]] <- myplot(data,"h.t", "m.to", var,col=cols[3],xlim=xlim, ylim=ylim)
addIsoclines(b=2)

xlim <- c(1E-4, 1)
f[[1]] <- myplot(data,"d.ba", "m.lf", var,col=cols[1],xlim=xlim, ylim=ylim)
addIsoclines(b=2)
f[[2]] <- myplot(data,"d.ba", "m.st", var,col=cols[2], xlim=xlim, ylim=ylim)
addIsoclines(b=2)
f[[3]] <- myplot(data,"d.ba", "m.so", var,col=cols[3],xlim=xlim, ylim=ylim)
addIsoclines(b=2)
f[[4]] <- myplot(data,"d.ba", "m.rt", var,col=cols[3],xlim=xlim, ylim=ylim)
addIsoclines(b=2)
f[[5]] <- myplot(data,"d.ba", "m.to", var,col=cols[3],xlim=xlim, ylim=ylim)
addIsoclines(b=2)
}

to.pdf(myfigure(),"output/figures/biomass.pdf", height= 8, width =12)

xlim <- c(1E-2, 100)
bivarPlotColorBy(data,"h.t", "m.so", "vegetation",col=make.transparent(niceColors(), 0.5), pch=16,type='b', legend=TRUE,xlim=xlim, ylim=ylim)

bivarPlotColorBy(data,"h.t", "m.so", "pft",col=make.transparent(niceColors(), 0.5), pch=16,type='b', legend=TRUE,xlim=xlim, ylim=ylim)
