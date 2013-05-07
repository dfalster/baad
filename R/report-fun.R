getContributors<-function(data){  
  data$contact[!duplicated(d$contact$name),]
}

extractStudy<-function(alldata, study){
  for(var in c("data", "ref", "contact"))
    alldata[[var]]<-alldata[[var]][alldata[[var]]$dataset == study,]
  alldata  
}


allStudyReport <- function(data, studynames, progressbar=TRUE){

  message("Generating ", length(studynames), " markdown reports.")
  if(progressbar){
    wp <- txtProgressBar(min = 0, max = length(studynames), 
                       initial = 0, width = 50, style=3)
  }

  for(i in seq_along(studynames)){
    studyReportMd(data, studynames[i])
    if(progressbar)setTxtProgressBar(wp, i)
  }
  
  if(progressbar)close(wp)
  
}

studyReport<-function(alldata, study="all"){
  if(study =="all")
    d<-alldata
  else
    d<- extractStudy(alldata, study)
  
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


makePlotPanel<-function(data, study, dir="report-per-study", col="grey", pdf=TRUE, quiet=FALSE){
  if(!quiet)cat("This is how the study", study, "fits in the entire dataset distribution")
  
  if(pdf){    
    path<-paste0("output/", dir)
    if(!file.exists(path))
      dir.create(path)
    pdf(file=paste0(path,"/", study,".pdf"))
  }
  
  dat        <-  data[data$dataset==study,]
  plot.vars  <-  var.def$Variable[var.def$Group=="tree"]
  plot.vars  <-  plot.vars[plot.vars %in% c("growingCondition","status","light") == FALSE]
  available  <-  dat[,names(dat) %in% plot.vars]   
  available  <-  apply(available,2,as.numeric)
  available  <-  available[,colSums(available, na.rm=TRUE) != 0]
  
  #set up a vector of colors, each species with different color
  species  <-  as.numeric(as.factor(dat$species))
  if(min(species)!=1){species  <-  species - (min(species)-1)}
  colorvec <-  niceColors(length(unique(species)))
  colorvec <-  colorvec[match(species, unique(species))]
  
  par(mfrow=c(2,2))
  z  <- 0
  for(j in 1:(dim(available)[2]-1)){
    for(k in (j+1):dim(available)[2]){
      testNa  <-  available[,j]+available[,k]
      if(length(testNa[!is.na(testNa)]) != 0){
        z  <-  z + 1
        if(z==5){par(mfrow=c(2,2)); z  <- 1}
        varjx  <-  paste0(var.def$label[var.def$Variable==colnames(available)[j]], " (", var.def$Units[var.def$Variable==colnames(available)[j]], ")")
        varjy  <-  paste0(var.def$label[var.def$Variable==colnames(available)[k]], " (", var.def$Units[var.def$Variable==colnames(available)[k]], ")")
        makePlot(data, available, studycol=colorvec, xvar = colnames(available)[j], yvar = colnames(available)[k],  xlab=varjx, ylab=varjy)
      }
    }
  }  
  if(pdf) 
    dev.off()
}

makePlot<-function(data, subset, xvar, yvar, xlab, ylab, main="", maincol="grey", studycol){
  
  plot(data[,xvar], data[,yvar], log="xy", col = maincol, xlab=xlab, ylab= ylab, main= main, las=1, yaxt="n", xaxt="n")
  
  #add nice log axes
  axis.log10(1) 
  axis.log10(2)
  
  #add data for select study, highlighted in red
  points(subset[,xvar], subset[,yvar], col = studycol)  
}  

prepMapInfo<-function(data, study){
  
  data   <-  data[study==data$dataset,]
  coord  <-  unique(paste0(data$latitude,";", data$longitude, ";", data$location))  
  data   <-  data.frame(lat=as.numeric(unlist(lapply(coord, function(x){strsplit(x,";")[[1]][1]}))),
                        lon=as.numeric(unlist(lapply(coord, function(x){strsplit(x,";")[[1]][2]}))),
                        loc=as.character(unlist(lapply(coord, function(x){strsplit(x,";")[[1]][3]}))),
                        country=NA,
                        stringsAsFactors=FALSE)
  i      <-  !is.na(data$lat) | !is.na(data$lon)
  if( any(i) ){
    data$country[i]  <-  as.character(strsplit(map.where(x=data$lon[i], y=data$lat[i]),":")[[1]][1])
  }  
  
  #final object
  data
  
}  

drawWorldPlot  <-  function(data){
  
  map('world',col="grey80",bg="white",lwd=0.5,fill=TRUE,resolution=0,wrap=TRUE, border="grey80")
  map('world',col="black",boundary=TRUE,lwd=0.2,interior=FALSE,fill=FALSE,add=TRUE,resolution=0,wrap=TRUE)
  lines(c(-180,180),c(-100,-100), lty="dashed", xpd=TRUE, lwd=2)
  lines(c(-180,180),c(100,100), lty="dashed", xpd=TRUE, lwd=2)
  
  j  <-  !is.na(data$lat) & !is.na(data$lon) & data$loc != "NA" | is.na(data$loc)
  
  if(length(j)==length(j[j==FALSE])){
    polygon(c(-100,95,95,-100), c(-10,-10,15,15), col=rgb(0,0,0,240,maxColorValue=255))
    text(-100, 0, expression(paste(bold("Missing coordinate/location"))), col="red", xpd=TRUE, pos=4, cex=0.8)
  } else {
    if( any(j) ){
      points(data$lon[j], data$lat[j], pch=19, col="red", bg="red", cex=0.6)
    }
  }
  
}

repMissingInfo  <-  function(data){
  j    <-  !is.na(data$lat) & !is.na(data$lon) & data$loc != "NA" | is.na(data$loc)
  sj   <-  data[j==FALSE,]
  
  #location Info
  k  <-  !is.na(sj$loc) & is.na(sj$lon)
  if(length(k[k==TRUE]) > 0){
    cat("Please notice that there are no coordinates for the following location(s):")
    return(cbind(sj$loc[k]))
  }
  #coordinate Info
  k  <-  !is.na(sj$lon) & is.na(sj$loc) | sj$loc=="NA"
  if(length(k[k==TRUE]) > 0){
    cat("Please notice that there is no location information for the following coordinate(s):")
    return(cbind(lon=sj$lon[k],lat=sj$lat[k]))
  }
  #country Info
  k  <-  !is.na(sj$loc) & is.na(sj$country)
  if(length(k[k==TRUE]) > 0){
    cat("Please notice that there is no country information for the following location(s):")
    return(cbind(sj$loc[k]))
    cat("The most likely reason is either a missing or wrong coordinate, please revise")
  }
}

drawCountryPlot  <-  function(data){
  mapCountries  <-  unique(data$country)
  mapCountries  <-  mapCountries[!is.na(mapCountries)]
  countriesLen  <-  length(mapCountries)
  ppoint        <-  rep(c(21,22,23,24,25),2)
  cpoint        <-  c("yellow","blue","darkgreen","red","grey","black","yellow","blue","darkgreen","red")
  
  #make map for each country
  for(g in mapCountries){
    zeta        <-  data$country==g
    subC        <-  data[which(zeta==TRUE),]
    
    if(nrow(subC) <= 10){
      
      par(mfrow=c(1,2), mar=c(4,4,5,1))
      if(g=="USA"){map("usa")} else {map("worldHires",g)}
      title(g)
      subC$group   <-  as.numeric(as.factor(paste0(subC$lon,subC$lat)))
      subC$cpoint  <-  cpoint[match(subC$group,1:10)]
      subC$ppoint  <-  ppoint[match(subC$group,1:10)]
      for(d in unique(subC$group)){
        subD  <-  subC[subC$group==d,]
        points(subD$lon[1], subD$lat[1], pch=subD$ppoint[1], col="black", bg=subD$cpoint[1], cex=0.8)
      }
      
      par(mar=c(2,0,2,0))
      plot(0,0,type="n",axes=FALSE,xlab="",ylab="",xlim=c(0,20),ylim=c(-2,12))
      for(i in c(10:1)[1:nrow(subC)]){
        points(0, i, pch=subC$ppoint[which(c(10:1)==i)], col="black", bg=subC$cpoint[which(c(10:1)==i)])
        text(0.3, i, subC$loc[which(c(10:1)==i)], pos=4, xpd=TRUE, cex=0.8)
      }    
      
    } else {
      subC$org  <-  as.integer(cut(1:nrow(subC), ceiling(nrow(subC)/10)))
      for(f in unique(subC$org)){
        subK         <-  subC[subC$org==f,]
        
        par(mfrow=c(1,2), mar=c(4,4,5,1))
        if(g=="USA"){map("usa")} else {map("worldHires",g)}
        title(g)
        subK$group   <-  as.numeric(as.factor(paste0(subK$lon,subK$lat)))
        subK$cpoint  <-  cpoint[match(subK$group,1:10)]
        subK$ppoint  <-  ppoint[match(subK$group,1:10)]
        for(d in unique(subK$group)){
          subD  <-  subK[subK$group==d,]
          points(subD$lon[1], subD$lat[1], pch=subD$ppoint[1], col="black", bg=subD$cpoint[1], cex=0.8)
        }
        
        par(mar=c(2,0,2,0))
        plot(0,0,type="n",axes=FALSE,xlab="",ylab="",xlim=c(0,20),ylim=c(-2,12))
        for(i in c(10:1)[1:nrow(subK)]){
          points(0, i, pch=subK$ppoint[which(c(10:1)==i)], col="black", bg=subK$cpoint[which(c(10:1)==i)])
          text(0.3, i, subK$loc[which(c(10:1)==i)], pos=4, xpd=TRUE, cex=0.8)
        }    
      }
    }
  }
}

locLevelInfo  <-  function(data){
  loc  <-  unique(paste(data$location, data$map, data$mat, data$longitude, data$latitude, data$vegetation, sep=";"))
  loc  <-  data.frame(Location=as.character(unlist(lapply(loc, function(x){strsplit(x,";")[[1]][1]}))),
                      MAP=as.numeric(unlist(lapply(loc, function(x){strsplit(x,";")[[1]][2]}))),
                      MAT=as.numeric(unlist(lapply(loc, function(x){strsplit(x,";")[[1]][3]}))),
                      Longitude=as.numeric(unlist(lapply(loc, function(x){strsplit(x,";")[[1]][4]}))),
                      Latitude=as.numeric(unlist(lapply(loc, function(x){strsplit(x,";")[[1]][5]}))),
                      Vegetation_Type=as.character(unlist(lapply(loc, function(x){strsplit(x,";")[[1]][6]}))),
                      stringsAsFactors=FALSE)
  
  loc[is.na(loc) | loc=="" | loc=="NA"]  <-  "????"  
  loc
}


standLevelInfo  <-  function(data){
  sta  <-  unique(paste(data$location, data$grouping, data$growingCondition, data$status, sep="&T&"))
  sta  <-  data.frame(Location=as.character(unlist(lapply(sta, function(x){strsplit(x,"&T&")[[1]][1]}))),
                      Grouping=as.character(unlist(lapply(sta, function(x){strsplit(x,"&T&")[[1]][2]}))),
                      Growing_condition=as.character(unlist(lapply(sta, function(x){strsplit(x,"&T&")[[1]][3]}))),
                      Status=as.character(unlist(lapply(sta, function(x){strsplit(x,"&T&")[[1]][4]}))),
                      stringsAsFactors=FALSE)
  
  if(length(which(is.na(sta$Grouping)==TRUE))==length(sta$Grouping) | length(which(sta$Grouping=="NA"))==length(sta$Grouping)){
    sta  <-  sta[,c("Location", "Growing_condition", "Status")]
  }
  sta[is.na(sta) | sta=="" | sta=="NA"]  <-  "????"  
  sta
}


spLevelInfo  <-  function(data){
  spec         <-  data.frame(species=as.character(unique(data$species)), stringsAsFactors=FALSE)
  for(z in c("family", "pft")){
    spec[[z]]  <-  as.character(data[[z]][match(spec$species,data$species)])
    i          <-  spec[[z]]=="" | is.na(spec[[z]]) 
    if(any(i)){
      spec[[z]][i]  <-  "????"
    }
  }
  j            <-  spec$species=="" | is.na(spec$species) 
  if(any(j)){
    spec$species[j]  <-  "????"
  }
  spec
}

printMeta  <-  function(data){
  dataset   <-  as.character(unique(data$dataset))
  openMeta  <-  read.csv(paste0("../",dir.rawData,"/",dataset,"/studyMetadata.csv"), h=TRUE, stringsAsFactors=FALSE)
  openMeta
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


#creates html reports using knitr
studyReportMd <- function(alldata, study=NULL, Dir="report-per-study", delete=TRUE){
  
  .study <- study
  .dat <- extractStudy(alldata, study)
  
  #Check output directory exists
  path<-paste0("output/", Dir)
  if(!file.exists(path)) dir.create(path)
  
  suppressMessages(knit2html("R/reportmd.Rmd", quiet=TRUE))
  
  file.copy("reportmd.html", paste0(path,"/",.study,"-report.html"))
  
  #delete support files
  if(delete){
    unlink("reportmd.md")
    unlink("reportmd.html")
    unlink("figure", recursive=TRUE) 
  }
  
}


generateAllDataNew <- function(data, studynames, progressbar=TRUE){
  
  if(progressbar){
  wp <- txtProgressBar(label = "", min = 0, max = length(studynames), 
                       initial = 0, width = 50, style=3)
  }
  
  for(i in seq_along(studynames)){
      generateDataNew(data,studynames[i])
      if(progressbar)setTxtProgressBar(wp, i)
  }
  if(progressbar)close(wp)
  
}

generateDataNew  <-  function(data, studyName){
  
  # Extract dataframe of observations only
  data <- data$data

  dat <- data[data$dataset == studyName, ]
  
  if(all(is.na(dat$location))){
    nloc  <-  NA
  } else {
    nloc  <-  length(unique(dat$location))
  }
  
  datnew  <-  data.frame()
  
  if(is.na(nloc)){
    datnew  <-  data.frame(lookupVariable="",
                           lookupValue="",
                           newVariable=c("location","latitude","longitude","map","mat","vegetation","growingCondition","status"),
                           newValue="",
                           source="",
                           stringsAsFactors=FALSE)
  } else {
    for(j in seq_len(nloc)){
      
      ob   <-  as.character(unique(dat$location)[j])
      su   <-  dat[dat$location==ob,c("latitude","longitude","map","mat","vegetation","growingCondition","status")]
      
      allNA    <-  sapply(su,function(x)all(is.na(x)))
      varsNA <- names(su)[allNA]
      
      if(any(allNA)){
        for(k in varsNA){
          datnew  <-  rbind(datnew, data.frame(lookupVariable="location",lookupValue=ob,
                                               newVariable=k,newValue="",source="",stringsAsFactors=FALSE))
        }
      } else {
        datnew  <-  rbind(datnew, data.frame(lookupVariable="location",lookupValue="",
                                             newVariable="",newValue="",source="",stringsAsFactors=FALSE))
      }
    }
  }
  
  spp  <-  as.character(unique(dat$species))
  fam  <-  as.character(dat$family[match(spp,dat$species)])
  pft  <-  as.character(dat$pft[match(spp,dat$species)])
  
  a  <-  is.na(fam)
  if(any(a)){
    datnew  <-  rbind(datnew, data.frame(lookupVariable="species",lookupValue=spp[a],
                                         newVariable="family",newValue="",source="",stringsAsFactors=FALSE))
  }  
  
  a  <-  is.na(pft)
  if(any(a)){
    datnew  <-  rbind(datnew, data.frame(lookupVariable="species",lookupValue=spp[a],
                                         newVariable="pft",newValue="",source="",stringsAsFactors=FALSE))
  }
  
  if(!file.exists(dir.Emails))
    dir.create(dir.Emails)
  
  tdir  <-  paste0(dir.Emails, "/", studyName)
  if(!file.exists(tdir)){
    dir.create(tdir)
  }
  write.csv(datnew, paste0(dir.Emails, "/", studyName, "/dataNew.csv"))
  
}


emailFiles  <-  function(data, studyName){
  contact    <-  read.csv(paste0(dir.rawData,"/",studyName,"/studyContact.csv"), h=TRUE,stringsAsFactors=FALSE)
  reference  <-  read.csv(paste0(dir.rawData,"/",studyName,"/studyRef.csv"), h=TRUE,stringsAsFactors=FALSE)
  write.csv(contact, paste0(dir.Emails,"/",studyName,"/studyContact.csv"))
  write.csv(reference, paste0(dir.Emails,"/",studyName,"/studyRef.csv"))
  write.csv(var.def, paste0(dir.Emails,"/",studyName,"/Variable_definitions.csv"))
}


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