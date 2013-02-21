#Conversion functions - converts unit before the dot into the unit after it
g.kg             <-  function(x){x/1000} #from g to kg
mg.kg            <-  function(x){x/1000000} #from mg to kg
cm2.m2           <-  function(x){x/10000} #from cm2 to m2
cm.m             <-  function(x){x/100} #from cm to m
mm.m             <-  function(x){x/1000} #from mm to m
months.yr        <-  function(x){x/12} #from months to yr
g.cm2.kg.m2      <-  function(x){x*10} #from g/cm2 to kg/m2
m2.kg.kg.m2      <-  function(x){1/x} #from m2/kg to kg/m2
cm2.g.kg.m2      <-  function(x){1/x*10} #from cm2/g to kg/m2
g.m2.kg.m2       <-  function(x){x/1000} #from g/m2 to kg/m2
g.cm3.kg.m3      <-  function(x){x*1000} #from g/cm3 to kg/cm3
per.kg.kg        <-  function(x){x/100} #from percentage to decimals
mm2.m2           <-  function(x){x/(10^6)} #from mm2 to m2
cm2.kg.kg.m2     <-  function(x){1000/x} #from cm2/kg to kg/m2
mmol.N.m2.kg.m2  <-  function(x){x*14e-6} #from mmol of nitrogen/m2 to kg/m2
Mg.kg            <-  function(x){x/1000} #from megagrams (Mg) to kg
g.l.kg.m3        <-  function(x){x} #from grams/litre to kg/m3


importData<-function(studyName){
  cat(studyName, " ")
  #read original data from file
  raw<-loadData(studyName) 
  
  #make dataframe
  #TODO: change c(3:12, 14:37, 39:45) to something more robust, e.g. colnames
  #remove not allowed columns
  source(paste0(dir.rawData,"/",studyName,"/makeDataFrame.R"))
  data<-makeDataFrame(raw, studyName)  
  
  #add studyname to dataset
  data<- cbind(data, dataset=studyName, stringsAsFactors=FALSE)
  
  #convert units and variable names
  data<-convertData(data, studyName)
  
  #expand columns to mirror those in final database
  data<-addAllColumns(data)
          
#   #import new data, if available
#   data<-addNewData(studyName, data)
  
  #write data to file  
  writeData(data, studyName)
  
  data
}

loadData<-function(studyName){
  #import options for data file
  import <-  read.csv(paste0(dir.rawData,"/",studyName,"/import.csv"), h=FALSE, row.names=1, stringsAsFactors=FALSE)   
  
  #brings in the original .csv
  raw     <-  read.csv(paste0(dir.rawData,"/",studyName,"/",import['name',]), h=(import['header',]=="TRUE"), skip=as.numeric(import['skip',]), stringsAsFactors=FALSE)
  raw
}

makeEmptyDataSet<-function(colnames){
  #start with empty dataframe with all variables included
  emptydfr <- data.frame( matrix("a", ncol=length(colnames),nrow=1), stringsAsFactors=FALSE)
  names(emptydfr) <- colnames
  emptydfr[-1,]
}

addAllColumns<-function(data){
  
  #all column names
  names<-var.def$Variable
  type<-var.def$Type
  #add methods
  names<-c(names, as.character(paste("method_", var.def$Variable[var.def$methodsVariable], sep=""))) 
  type<-c(type, rep("character",sum(var.def$methodsVariable)))
  
  #TODO: check no illegal columns
  #check which variable already present
  present<- (names %in% names(data))
  for(i in 1:length(names))
    if(!present[i]){  #variable not present, add
      data[,names[i]] = NA
      class(data[,names[i]])<-type[i]
    }  
  data[,names]
}


addNewData<-function(studyName, data){
  #import options for data file
  filename<-paste0(dir.rawData,"/",studyName,"/dataNew.csv")
  if(file.exists(filename)){
    import <-  read.csv(filename, h=TRUE, stringsAsFactors=FALSE) #read in new data    
    for (i in 1:length(import[,1])){
      if(is.na(import$lookupVariable[i])) #apply to whole column
        data[,import$newVariable[i]] = import$newValue[i]
      else  #apply to subset
        data[data[,import$lookupVariable[i] ]==import$lookupValue[i],import$newVariable[i] ] = import$newValue[i]
    }  
  }
  data
}
  
  
#Define a function for that constructs dataframe for this study
#NOTE - this is just a template. this function is redfined for each study 
# See file makeDataFrame.R stored in its each studies directory
makeDataFrame<-function(raw, studyName){
  data  <-  NULL
}

#convert data to desired format, changing units, variable names
convertData<-function(data,studyName){
  
  #load variable matching table
  var.match <- read.csv(paste0(dir.rawData,"/",studyName,"/variable.match.csv"),h=TRUE,stringsAsFactors=FALSE,na.strings=c("NA",""))
  #browser()
  #Find the column numbers in the data that need to be checked out for conversion
  selec  <-  which(names(data) %in% var.match$var_in) 
  
  for(a in selec){    #Do for every column that needs conversion
    #rename data
    #TODO: put this in a function
    var.in   <-  names(data)[a] #variable that goes in
    var.out  <-  var.match$var_out[var.match$var_in==var.in] #variable that goes out   
    names(data)[a] <-  var.out #resets the name of a particular variable to the standardised form
    
    #change units  
    #TODO: put this in a function
    un.in    <-  var.match$unit_in[var.match$var_in==var.in] #unit that goes in
    un.out   <-  var.def$Units[var.def$Variable==var.out] #unit that goes out
    
    if(un.in != un.out){
      func     <-  get(paste(un.in, ".", un.out, sep="")) #select the function based on variables
      data[,a] <-  func(as.numeric(data[,a])) #applies the function to the column
    }
    
    #outline methods
    #TODO: put this in a function
    met.in   <-  var.match$method[var.match$var_in==var.in] #method used to measure
    
    if(!is.na(met.in)){ # 
      #TODO: DIEGO - why not use method abbreviation?
      data$NEW                 <-  rep(met.in, nrow(data)) #creates a new colum that contains the method description
      names(data)[ncol(data)]  <-  paste("method", "_", var.out, sep="") #changes the names by pasting "method" and the standardised variable name 
    }
  }
  data
}

#write data to file
writeData<-function(data, name= data$dataset[1]){
  write.csv(data, paste0(dir.cleanData,"/", name, ".csv", sep=""), row.names=FALSE)
}

# smart Rbind - doesn't require exact match between columns of the two datasets. takes variable list from the first dataframe
Rbind <- function (dfr1, dfr2) 
{
  if(is.null(dfr1) | is.null(dfr2))
    stop("Empty dataframe passed to Rbind")

  merger <- vector("list", ncol(dfr1))
  names(merger) <- names(dfr1)
  for (i in 1:length(merger)) {
    nam <- names(merger)[i]
    if (!(nam %in% names(dfr2))) 
      merger[[i]] <- rep(NA, nrow(dfr2))
    else merger[[i]] <- dfr2[, nam]
  }
  dfr <- rbind(dfr1, as.data.frame(merger))
  return(dfr)
}

