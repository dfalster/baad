rm(list=ls())

source('report/report-fun.R')

#names of all studies
dat <- loadStudies(reprocess=FALSE)
data <- dat$data

saveRDS(data, file="cache/allomdata.rds")



getAttributeByStudy <- function(data, var, studies){
  i <- !is.na(data[[var]])
  data[c("dataset", var)][!duplicated(paste( data[["dataset"]], data[[var]])),]
}

var <- "species"
n = 20
v <- data.frame(x = rep("",n), y= rep("",n), g = rep("",n), stringsAsFactors=FALSE)
v[1,] <- c("h.t", "a.lf", var)
v[2,] <- c("h.t", "m.lf", var)
v[3,] <- c("h.t", "m.st", var)
v[4,] <- c("m.lf", "m.st", var)
v[5,] <- c("a.lf", "m.st", var)
v[6,] <- c("a.stbh", "m.st", var)
v[7,] <- c("a.stbh", "a.lf", var)
v[8,] <- c("d.bh", "m.lf", var)
v[9,] <- c("d.bh", "m.so", var)

for(i in seq_len(9)){
  myplots <- function(){
    bivarPlotColorBy(data, v$x[i], v$y[i], group = v$g[i],col = make.transparent("grey", 0.2), pch=16, lwd=2, type='p')
    bivarPlotColorBy(data, v$x[i], v$y[i], group = v$g[i],lwd=1, type='l', add=TRUE)
  }

  to.pdf(myplots(),paste0("output/", var,"/plot-", i,".pdf"), height= 6, width =8)
}

#World map
to.pdf(
  drawWorldPlot (prepMapInfo(data))
  ,"output/talk/figures/map.pdf", height= 4, width =6)
