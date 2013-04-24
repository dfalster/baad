comparePlots<-function(alldata, dir="report/pairwise_plots", col="grey", pdf=FALSE){
  
  plot.vars  <-  var.def$Variable[var.def$Group=="tree"]
  plot.vars  <-  plot.vars[plot.vars %in% c("growingCondition","status","light") == FALSE]
  available  <-  alldata[,names(alldata) %in% plot.vars]   
  available  <-  apply(available,2,as.numeric)
  available  <-  available[,colSums(available, na.rm=TRUE) != 0]
  
  par(mfrow=c(2,2))
  z  <- 0
  for(j in 1:(dim(available)[2]-1)){
    
    for(k in (j+1):dim(available)[2]){
      varjx  <-  paste0(var.def$label[var.def$Variable==colnames(available)[j]], " (", var.def$Units[var.def$Variable==colnames(available)[j]], ")")
      varjy  <-  paste0(var.def$label[var.def$Variable==colnames(available)[k]], " (", var.def$Units[var.def$Variable==colnames(available)[k]], ")")
      
      if(pdf){    
        path<-paste0("output/", dir)
        
        if(!file.exists(path))
          dir.create(path)
        pdf(file=paste0(path,"/", colnames(available)[j],"-vs-",colnames(available)[k],".pdf"))
      }
      
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

makePlot<-function(data, subset, xvar, yvar, xlab, ylab, main="", maincol="grey", studycol){
  
  plot(data[,xvar], data[,yvar], log="xy", col = maincol, xlab=xlab, ylab= ylab, main= main, las=1, yaxt="n", xaxt="n")
  
  #add nice log axes
  axis.log10(1) 
  axis.log10(2)
  
  #add data for select study, highlighted in red
  points(subset[,xvar], subset[,yvar], col = studycol)  
}  

is.wholenumber <-  function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol

axis.log10 <- function(side=1, horiz=FALSE, labels=TRUE, wholenumbers=T, labelEnds=T,las=1) {
  fg <- par("fg")
  
  #get range on axis
  if(side ==1 | side ==3) {    
    r <- par("usr")[1:2]   #upper and lower limits of x-axis
  } else {
    r <- par("usr")[3:4] #upper and lower limits of y-axis    
  }
  
  #make pertty intervals
  at <- pretty(r)
  #drop ends if desirbale
  if(!labelEnds)
    at <- at[at > r[1] & at < r[2]]
  #restrict to whole numbers if desriable
  if(wholenumbers)
    at<-at[is.wholenumber(at)]
  
  #make labels
  if ( labels ) {
    lab <- do.call(expression, lapply(at, function(i) bquote(10^.(i))))
    axis(side, at=10^at, lab, col=if(horiz) fg else NA,
         col.ticks=fg, las=las) 
  } else {
    axis(side, at=10^at, FALSE, col=if(horiz) fg else NA,
         col.ticks=fg, las=las)
  }
}

## Make colours semitransparent:
make.transparent <- function(col, opacity=0.5) {
  if (length(opacity) > 1 && any(is.na(opacity))) {
    n <- max(length(col), length(opacity))
    opacity <- rep(opacity, length.out=n)
    col <- rep(col, length.out=n)
    ok <- !is.na(opacity)
    ret <- rep(NA, length(col))
    ret[ok] <- Recall(col[ok], opacity[ok])
    ret
  } else {
    tmp <- col2rgb(col)/255
    rgb(tmp[1,], tmp[2,], tmp[3,], alpha=opacity)
  }
}

#returns up to 80 nice colors, generated using http://tools.medialab.sciences-po.fr/iwanthue/
niceColors<-function(n=80){
  cols<-c("#75954F","#D455E9","#E34423","#4CAAE1","#451431","#5DE737","#DC9B94","#DC3788","#E0A732","#67D4C1","#5F75E2","#1A3125","#65E689","#A8313C","#8D6F96","#5F3819","#D8CFE4","#BDE640","#DAD799","#D981DD","#61AD34","#B8784B","#892870","#445662","#493670","#3CA374","#E56C7F","#5F978F","#BAE684","#DB732A","#7148A8","#867927","#918C68","#98A730","#DDA5D2","#456C9C","#2B5024","#E4D742","#D3CAB6","#946661","#9B66E3","#AA3BA2","#A98FE1","#9AD3E8","#5F8FE0","#DF3565","#D5AC81","#6AE4AE","#652326","#575640","#2D6659","#26294A","#DA66AB","#E24849","#4A58A3","#9F3A59","#71E764","#CF7A99","#3B7A24","#AA9FA9","#DD39C0","#604458","#C7C568","#98A6DA","#DDAB5F","#96341B","#AED9A8","#55DBE7","#57B15C","#B9E0D5","#638294","#D16F5E","#504E1A","#342724","#64916A","#975EA8","#9D641E","#59A2BB","#7A3660","#64C32A")
  cols[1:n]
}
