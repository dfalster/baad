
importData<-function(studyName, verbose=FALSE){
  if(verbose) cat(studyName, " ")
  
  #read original data from file
  if(verbose) cat("load data ")
  
  raw<-loadData(studyName) 

#  browser()
  
  #Manipulate data where needed
  if(verbose) cat("manipulate data ")
  filename<-paste0(dir.rawData,"/",studyName,"/dataManipulate.R")
  if(file.exists(filename))
    source(filename, local=TRUE)
  
  #add studyname to dataset
  data<- cbind(raw, dataset=studyName, stringsAsFactors=FALSE)
  
  #convert units and variable names
  if(verbose) cat("convert units ")
  data<-convertData(data, studyName)

  #Remove / add columns to mirror those in final database
  if(verbose) cat("add/remove columns ")
  data<-addAllColumns(data)
          
  #import new data, if available
  if(verbose) cat("import new data ")
  data<-addNewData(studyName, data)
  
  #write data to file
  if(verbose) cat("write to file ")
  writeData(data, studyName)  
  data
}

loadData<-function(studyName){
  #import options for data file
  import <-  read.csv(paste0(dir.rawData,"/",studyName,"/dataImportOptions.csv"), h=FALSE, row.names=1, stringsAsFactors=FALSE)   
  
  #brings in the original .csv
  raw     <-  read.csv(paste0(dir.rawData,"/",studyName,"/",import['name',]), h=(import['header',]=="TRUE"), skip=as.numeric(import['skip',]), stringsAsFactors=FALSE)
  raw
}

addAllColumns<-function(data){
  
  #all column names
  allowedNames<-var.def$Variable
  type<-var.def$Type
  #add methods
  allowedNames<-c(allowedNames, as.character(paste("method_", var.def$Variable[var.def$methodsVariable], sep=""))) 
  type<-c(type, rep("character",sum(var.def$methodsVariable)))
  
  #remove columns no in final variable list
  present<- (names(data)%in%allowedNames)
  data<-data[,present]  
  
  #check which variable already present
  present<- (allowedNames %in% names(data))
  for(i in 1:length(allowedNames))
    if(!present[i]){  #variable not present, add
      data[,allowedNames[i]] = NA
      class(data[,allowedNames[i]])<-type[i]
    }  
  data[,allowedNames] #return in desired order
}


addNewData<-function(studyName, data){
  #import options for data file
  filename<-paste0(dir.rawData,"/",studyName,"/dataNew.csv")
  if(file.exists(filename)){
   import <-  read.csv(filename, h=TRUE, stringsAsFactors=FALSE, strip.white = TRUE) #read in new data    
   nchanges<- length(import$lookupVariable)
   if(nchanges){
      for (i in 1:nchanges){
        if(is.na(import$lookupVariable[i]) | import$lookupVariable[i] =="") #apply to whole column
          data[,import$newVariable[i]] = import$newValue[i]
        else  #apply to subset
          data[data[,import$lookupVariable[i] ]==import$lookupValue[i],import$newVariable[i] ] = import$newValue[i]
      }   
    }      
  }
  data
}
  
#convert data to desired format, changing units, variable names
convertData<-function(data,studyName){
  
  #load variable matching table
  var.match <- read.csv(paste0(dir.rawData,"/",studyName,"/dataMatchColumns.csv"),h=TRUE,stringsAsFactors=FALSE,na.strings=c("NA",""))

  #Find the column numbers in the data that need to be checked out for conversion
  selec  <-  which(names(data) %in% var.match$var_in) 
  
  for(a in selec){    #Do for every column that needs conversion
    #rename data
    var.in   <-  names(data)[a] #variable that goes in
    var.out  <-  var.match$var_out[var.match$var_in==var.in] #variable that goes out   
    names(data)[a] <-  var.out #resets the name of a particular variable to the standardised form
    
    #change units  
    un.in    <-  var.match$unit_in[var.match$var_in==var.in] #unit that goes in
    un.out   <-  var.def$Units[var.def$Variable==var.out] #unit that goes out
    
    if(un.in != un.out){
      func     <-  get(paste(un.in, ".", un.out, sep="")) #select the function based on variables
      data[,a] <-  func(as.numeric(data[,a])) #applies the function to the column
    }
    
    #add methods varaibles
    met.in   <-  var.match$method[var.match$var_in==var.in] #method used to measure
    
    if(!is.na(met.in)){ # 
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
