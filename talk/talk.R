source('report/report-fun.R')
data<- loadStudies(reprocess=FALSE)$data


to.pdf(
  drawWorldPlot (prepMapInfo(data))
  ,"talk/figures/map.pdf", height= 4, width =6)

to.pdf(
  highlightStudies(data, "h.t","a.lf", "species", c("Martin1998", "Aiba2005"))
  ,"talk/figures/H-A.pdf", height= 6, width =8)
# add  pas used  a1 = 5.44;      B1= 0.306; 

bivarPlotColorBy(data[data$dataset=="Martin1998",], "a.lf", "h.t","species", pch=19)

tmp <- bivarPlotColorBy(data, "a.lf", "h.t", group = "vegetation", pch=19)       

  
--- 

## Nice plots
```{r, echo=FALSE, warning=FALSE}
tmp <- bivarPlotColorBy(data, "m.st", "h.t",colorBy = data$vegetation)
bivarPlot.Legend(tmp)
```

--- 

## The end of 3/4 scaling?
```{r, echo=FALSE, warning=FALSE}
tmp <- bivarPlotColorBy(data, "m.st", "m.lf",colorBy = data$pft)
bivarPlot.Legend(tmp)
```



