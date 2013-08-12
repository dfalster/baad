rm(list=ls())

source('report/report-fun.R')

#names of all studies
dat <- loadStudies(reprocess=FALSE)
data <- dat$data

options(error = recover)

out<-bivarPlotColorBy(data,  "h.t", "a.lf", "vegetation", legend=TRUE, pch=19, lwd=2)

# datasets without vegetation type sepcified
i <- is.na(data$data$vegetation)

getAttributeByStudy <- function(data, var, studies){
  i <- !is.na(data[[var]])
  data[c("dataset", var)][!duplicated(paste( data[["dataset"]], data[[var]])),]
}


# Geographic
# - Europe
# - tropical

## Overview of data provided

summarytStats <- function(data, var = NA){
  if(!is.na(var) & var %in% names(data))
    data <- data[ !is.na(data[[var]]) ,]
  paste0("Data for ", length(data$dataset)," individuals from ", length(unique(data$location)), " locations covering ", length(unique(data$species)), " species.")
}


summarytStats(data)

summarytStats(data, "m.st")

#World map
to.pdf(
  drawWorldPlot (prepMapInfo(data))
  ,"output/talk/figures/map.pdf", height= 4, width =6)

to.pdf(
  highlightStudies(data[data$dataset %in% c("Martin1998", "Aiba2005"), ], "h.t","a.lf", "species", c("Martin1998", "Aiba2005"), pch=19)
  ,"output/talk/figures/H-A-Aiba-Martin-only.pdf", height= 6, width =8)

to.pdf(
  highlightStudies(data, "h.t","a.lf", "species", c("Martin1998", "Aiba2005"), pch=19)
  ,"output/talk/figures/H-A-Aiba-Martin-all.pdf", height= 6, width =8)

n = 20
v <- data.frame(x = rep("",n), y= rep("",n), g = rep("",n), stringsAsFactors=FALSE)
v[1,] <- c("h.t", "a.lf", "pft")
v[2,] <- c("h.t", "a.lf", "vegetation")
v[3,] <- c("h.t", "m.lf", "vegetation")
v[4,] <- c("h.t", "m.st", "vegetation")
v[5,] <- c("m.lf", "m.st", "vegetation")
v[6,] <- c("a.lf", "m.st", "vegetation")
v[7,] <- c("a.stbh", "m.st", "vegetation")
v[8,] <- c("a.stbh", "a.lf", "vegetation")
v[9,] <- c("a.ssbh", "a.lf", "vegetation")
v[10,] <- c("d.bh", "m.lf", "vegetation")
v[11,] <- c("d.bh", "m.so", "vegetation")

# sum up basal areas where exist
# data$m.st = rowSums(data[c("m.ss", "m.sh", "m.sb")])
# data$m.so = rowSums(data[c("m.lf", "m.st"))

for(i in seq_len(11))
  to.pdf(
    tmp <- bivarPlotColorBy(data, v$x[i], v$y[i], group = v$g[i], pch=19, legend= TRUE)
    ,paste0("output/talk/figures/plot-", i,".pdf"), height= 6, width =8)


# fig.txt<-function(i) paste0("\\includegraphics<",i,">[width=\textwidth]{figures/plot-",i,".pdf}")
# sapply(1:9, fig.txt)
