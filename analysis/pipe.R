source('report/report-fun.R')
source('R/fillDerivedVariables.R')

#names of all studies
dat <- loadStudies(reprocess=FALSE)
data <- fillDerivedVariables(dat$data)

saveRDS(data, file="cache/allomdata.rds")



getAttributeByStudy <- function(data, var, studies){
  i <- !is.na(data[[var]])
  data[c("dataset", var)][!duplicated(paste( data[["dataset"]], data[[var]])),]
}

addIsoclines <- function(A= seq(-10,10),...){
  for(a in A) abline(a,1,lty="dotted",...)
}

myplot <- function(data, xvar,yvar,g,add=FALSE,col=niceColors(1),add11=TRUE,...){
  bivarPlotColorBy(data, xvar, yvar,g,col=make.transparent("grey", 0.4), pch=16,type='p',add=add,...)
  bivarPlotColorBy(data, xvar, yvar,group=g,col=col,lwd=1, type='l', add=TRUE)
 }


myfigure <- function(){


par(mfrow=c(2,4), oma = c(4,4,4,4))
var <- "species"
xlim <- c(10^-7, 1)
ylim <- c(10^-5, 10^3)
cols <- niceColors(3)

f <- list()
f[[1]] <- myplot(data,"a.stba", "a.lf", var,col=cols[1],xlim=xlim, ylim=ylim, main = "base")
addIsoclines()
f[[2]] <- myplot(data,"a.stbh", "a.lf", var,col=cols[2], xlim=xlim, ylim=ylim, main = "breast")
addIsoclines()
f[[3]] <- myplot(data,"a.stbc", "a.lf", var,col=cols[3],xlim=xlim, ylim=ylim, main = "crown base")
addIsoclines()

bivarPlotColorBy(data, "a.stba", "a.lf", var,type='l', col=cols[1], xlim=xlim, ylim=ylim, main = "all")
bivarPlotColorBy(data, "a.stbh", "a.lf", var, type='l', col=cols[2], add=TRUE)
bivarPlotColorBy(data, "a.stbc", "a.lf", var, type='l', col=cols[3], add=TRUE)
addIsoclines()
mtext("Total stem", side=4)

f <- list()
f[[1]] <- myplot(data,"a.ssba", "a.lf", var,col=cols[1],xlim=xlim, ylim=ylim, main = "base")
addIsoclines()
f[[2]] <- myplot(data,"a.ssbh", "a.lf", var,col=cols[2], xlim=xlim, ylim=ylim, main = "breast")
addIsoclines()
f[[3]] <- myplot(data,"a.ssbc", "a.lf", var,col=cols[3],xlim=xlim, ylim=ylim, main = "crown base")
addIsoclines()

bivarPlotColorBy(data, "a.ssba", "a.lf", var, type='l', col=cols[1], xlim=xlim, ylim=ylim, main = "all")
bivarPlotColorBy(data, "a.ssbh", "a.lf", var, type='l', col=cols[2], add=TRUE)
bivarPlotColorBy(data, "a.ssbc", "a.lf", var, type='l', col=cols[3], add=TRUE)
addIsoclines()
mtext("Sapwood", side=4)
}

to.pdf(myfigure(),"output/figures/pipe.pdf", height= 8, width =12)
