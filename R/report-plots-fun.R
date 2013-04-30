comparePlots<-function(alldata, dir="plot-report", col="grey", pdf=TRUE){
  
  plot.vars  <-  var.def$Variable[var.def$Group=="tree"]
  plot.vars  <-  plot.vars[plot.vars %in% c("growingCondition","status","light") == FALSE]
  available  <-  alldata[,names(alldata) %in% plot.vars]   
  available  <-  apply(available,2,as.numeric)
  available  <-  available[,colSums(available, na.rm=TRUE) != 0]
  
  par(mfrow=c(2,2))
  
  for(j in 1:(dim(available)[2]-1)){
    
    for(k in (j+1):dim(available)[2]){
      varjx  <-  paste0(var.def$label[var.def$Variable==colnames(available)[j]], " (", var.def$Units[var.def$Variable==colnames(available)[j]], ")")
      varjy  <-  paste0(var.def$label[var.def$Variable==colnames(available)[k]], " (", var.def$Units[var.def$Variable==colnames(available)[k]], ")")
      testNa   <-  available[,j]+available[,k]
      if(length(testNa[!is.na(testNa)]) != 0){
        if(pdf){    
          path<-paste0("output/", dir)
          
          if(!file.exists(path))
            dir.create(path)
          pdf(file=paste0(path,"/", colnames(available)[j],"-vs-",colnames(available)[k],".pdf"))
        }

        z  <- 0
        for(g in as.character(unique(alldata$dataset))){
          subdata  <-  available[alldata$dataset==g,]
          testNa   <-  subdata[,j]+subdata[,k]
          if(length(testNa[!is.na(testNa)]) != 0){
            z  <-  z + 1
            if(z==5){par(mfrow=c(2,2)); z  <- 1}
            makePlot(alldata, subdata, studycol="red", xvar = colnames(subdata)[j], yvar = colnames(subdata)[k],  xlab=varjx, ylab=varjy, main=g)
            
          }
        }
        if(pdf) 
          dev.off()
      }
    }  
  }
}