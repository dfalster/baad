
getContributors<-function(data){  
  data$contact[!duplicated(d$contact$name),]
}

extractThisStduy<-function(alldata, study){
  for(var in c("data", "ref", "contact"))
    alldata[[var]]<-alldata[[var]][alldata[[var]]$dataset == study,]
  alldata  
}

studyReport<-function(alldata, study="all"){
  if(study =="all")
    d<-alldata
  else
    d<- extractThisStduy(alldata, study)
  
  cat("\nSTUDIES: ", as.character(unique(d$data$dataset)), "\n")
  
  cat("Data for",  length(d$data$dataset),"individuals from", length(unique(d$data$location)), "locations covering",  length(unique(d$data$species)), "species.\n\n")
  
  cat("\nNUMBER OF RECORDS FOR EACH VARIABLE: \n")  
  counts<-apply(!is.na(d$data), MARGIN=2, FUN = sum)
  counts<-counts[counts>0]  #only include no zeros
  #only include tree variables
  (counts<-counts[names(counts)%in%var.def$Variable[var.def$Group=="tree"]])

  cat("\nMORE DETAIL:\n")  
  cat("\nSITES:\n")  
  cat("\nprint information for each site, ie. ", var.def$Variable[var.def$Group=="site"])  
  cat("\nmap of locations used")  
  
  cat("\nSPECIES: ", length(unique(d$data$species)), "\n", paste0(as.character(unique(sort(d$data$species))), "; "), "\n")
  cat("\nprint information for each species, ie. ", var.def$Variable[var.def$Group=="species"])  
  cat("\n also number of records for each species")  
  
  #Brief look at data
  makePlotPanel(alldata$data, study, pdf=FALSE)
  
}
  

#Reporting 2013.03.01
writeEmail<-function(d, fileName=paste("output/Email.txt", sep='')){
  cat(sprintf('%s,', unique(d$contact$email)), file= fileName)
  cat("\n\nDear contributors to the Biomass and Allometry database, (", file= fileName, append= TRUE)
  cat(sprintf('%s,', getContributors(d)$name), file= fileName, append= TRUE)
  cat(")\n\n", file= fileName, append= TRUE)
  cat("We have data for",  length(d$data$dataset),"individuals from", length(unique(d$data$dataset)), "studies covering",  length(unique(d$data$species)), "species.\n\n", file= fileName, append= TRUE)
  cat("The full list of studies included in the study is:\n", file= fileName, append= TRUE)
  cat(sprintf('  %s\n',d$ref[,2]), file= fileName, append= TRUE)
  cat("\n\nThe species included in the study are:\n", file= fileName, append= TRUE)
  cat(sprintf('%s,', sort(unique(as.character(d$data$species)))), file= fileName, append= TRUE)
}


makePlotPanel<-function(data, study, dir="report", col="grey", pdf=TRUE){
  cat(study, " ")
  
  if(pdf){    
    path<-paste0("output/", dir)
    if(!file.exists(path))
      dir.create(path)
    pdf(file=paste0(path,"/", study,".pdf"))
  }
  
  par(mfrow=c(2,2))
  makePlot(data, study, col=col, xvar = "h.t", yvar = "m.lf",  xlab="height (m)", ylab= "leaf mass (kg)", main = study)
  makePlot(data, study, col=col, xvar = "h.t", yvar = "a.lf",  xlab="height (m)", ylab= expression(paste("leaf area (",m^2,")")))
  makePlot(data, study, col=col, xvar = "h.t", yvar = "m.st",  xlab="height (m)", ylab= "stem mass (kg)")
  makePlot(data, study, col=col, xvar = "m.lf", yvar = "m.st",  xlab="leaf mass (kg)", ylab= "stem mass (kg)")  
  if(pdf) 
    dev.off()
}

makePlot<-function(data, study, xvar, yvar, xlab, ylab, main="", col="grey"){
  i<-(study==data$dataset)
  plot(data[,xvar], data[,yvar], log="xy", col = col, xlab=xlab, ylab= ylab, main= main, las=1, yaxt="n", xaxt="n")
  
  #add nice log axes
  axis.log10(1) 
  axis.log10(2)
  
  #add data for select study, highlighted in red
  points(data[i,xvar], data[i,yvar], col = "red")  
}

makeMapPlot<-function(data, study, dir="report", pdf=TRUE){
  
  datum  <-  data[study==data$dataset,]
  coord  <-  unique(paste0(datum$latitude,";", datum$longitude, ";", datum$location))  
  catdat <-  data.frame(lat=as.numeric(unlist(lapply(coord, function(x){strsplit(x,";")[[1]][1]}))),
                        lon=as.numeric(unlist(lapply(coord, function(x){strsplit(x,";")[[1]][2]}))),
                        loc=as.character(unlist(lapply(coord, function(x){strsplit(x,";")[[1]][3]}))),
                        stringsAsFactors=FALSE)
  
  catdat$colour  <-  as.character(sample(colors(),nrow(catdat)))
  ytext          <-  c(seq(-100,-180,length.out=10), seq(100,180,length.out=10))
  
  #if the study has more than 20 coordinates, then we need to split it, otherwise the maps can't be read
  if(nrow(catdat) <= 20){
    catdat$ytxt    <-  ytext[1:nrow(catdat)]
    catdat$xtxt    <-  rep(-175, nrow(catdat))
    drawPlot(catdat, study=study, dir=dir, pdf=pdf)
  } else {
    catdat$org  <-  as.integer(cut(1:nrow(catdat), ceiling(nrow(catdat)/20)))
    for(j in unique(catdat$org)){
      cutdat         <-  catdat[catdat$org==j, ]
      cutdat$ytxt    <-  ytext[1:nrow(cutdat)]
      cutdat$xtxt    <-  rep(-175, nrow(cutdat))
      drawPlot(cutdat, study=paste0(study, "_part_",j), dir=dir, pdf=pdf)
    }
  }
  
}


drawPlot  <-  function(catdat, study, dir="report", pdf=TRUE){
  if(pdf){    
    path<-paste0("output/", dir)
    if(!file.exists(path))
      dir.create(path)
    pdf(file=paste0(path,"/mapPlot_", study,".pdf"))
  }
  
  map('world',col="grey80",bg="white",lwd=0.5,fill=TRUE,resolution=0,wrap=TRUE, border="grey80")
  map('world',col="black",boundary=TRUE,lwd=0.2,interior=FALSE,fill=FALSE,add=TRUE,resolution=0,wrap=TRUE)
  
  if(is.na(catdat$lat) & is.na(catdat$lon) & catdat$loc=="NA"){
    polygon(c(-100,95,95,-100), c(-10,-10,15,15), col=rgb(0,0,0,240,maxColorValue=255))
    text(-100, 0, expression(paste(bold("Missing coordinate/location"))), col="red", xpd=TRUE, pos=4, cex=0.8)
  } else {
    for(k in 1:nrow(catdat)){
      lat=catdat$lat[k]
      lon=catdat$lon[k]
      loc=catdat$loc[k]
      colour=catdat$colour[k]
      ytxt=catdat$ytxt[k]
      xtxt=catdat$xtxt[k]
      
      if(!is.na(lat) & !is.na(lon) & lat != "" & lon != ""){
        points(lon, lat, pch=21, col="black", bg=colour, cex=0.9)
        points(xtxt, ytxt, pch=21, col="black", bg=colour, cex=0.9, xpd=TRUE)
        if(length(loc)==0 | loc=="NA"){
          text(xtxt, ytxt, "Missing location information", col="black", xpd=TRUE, pos=4, cex=0.7)
        } else {
          text(xtxt, ytxt, paste0(loc, "; lat=", lat, "; lon=", lon), col="black", xpd=TRUE, pos=4, cex=0.7)
        }  
        
      } else {  
        points(xtxt, ytxt, pch=23, col="black", bg="red", cex=1.2, xpd=TRUE)
        if(length(loc)==0 | loc=="NA"){
          text(xtxt, ytxt, "Missing coordinate for some data", col="black", xpd=TRUE, pos=4, cex=0.7)
        } else {
          text(xtxt, ytxt, paste0("Missing coordinate for ", loc), col="black", xpd=TRUE, pos=4, cex=0.7)
        }
      }
      
    }
  }
  if(pdf) 
    dev.off()
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
