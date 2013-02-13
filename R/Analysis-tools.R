
#make names lowercase
lownames <- function(x)tolower(names(x))

#

#some nice colours
col <- c("blue2", "goldenrod1", "firebrick2", "chartreuse4", 
         "deepskyblue1", "darkorange1", "darkorchid3", "darkgrey", 
         "mediumpurple1", "orangered2", "chocolate", "burlywood3", 
         "goldenrod4", "darkolivegreen2", "palevioletred3", 
         "darkseagreen3", "sandybrown", "tan", "gold", "violetred4", 
         "darkgreen")

col<-c(col, col, col)

#make plot of colours and groupnames
plotColours<-function(names, cols, cex=1){
  plot(0, 0, type='n', xlim=c(0,10), ylim=c(0,length(names)+2), ann=F, yaxt="n", xaxt="n")
  text(7, length(names)-1, "colour scheme", cex=2)    
  for(i in 1:length(names)){
    points(0.5,1+i, col=cols[i])
    text(1, 1+i, names[i], col=cols[i], cex=cex, pos=4)  
  }
  cbind(unique(names), cols)
}

#fit sma to 
colourByGroup<-function(data, groupFitName, colourName, YName, XName, log="xy", add=T, col=NA, minNumPoints=6){
  
  if(is.na(col[1])) col <- c("blue2", "goldenrod1", "firebrick2", "chartreuse4", 
                          "deepskyblue1", "darkorange1", "darkorchid3", "darkgrey", 
                          "mediumpurple1", "orangered2", "chocolate", "burlywood3", 
                          "goldenrod4", "darkolivegreen2", "palevioletred3", 
                          "darkseagreen3", "sandybrown", "tan", "gold", "violetred4", 
                          "darkgreen")
  grps<-unique(data[,colourName])
  ngrps<-length(grps)
  
  for(i in 1:ngrps){
    dataNew<-data[data[, colourName]== grps[i],]
    if(min(sum(!is.na(dataNew[,YName])), sum(!is.na(dataNew[,XName]))) >6){
      cat(i, " ", grps[i], " ", length(dataNew[,1]), " || ")    
      #if(grps[i]=="Lusk")  browser() 
      sm<- sma(dataNew[,YName]~dataNew[,XName]*dataNew[,groupFitName], log=log)
      plot(sm, add=add, col=col[i])     
    }
    else{
      cat(i, " ", grps[i], " ", length(dataNew[,1]), "excluded || ")  
    }      
  } 
  #  browser() 
}

