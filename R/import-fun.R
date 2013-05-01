
#first create a dataImportOptions.csv for each new study
makeDataImport  <-  function(newStudy){
  impo      <-  data.frame(name=c("header","skip"),data.csv=c(TRUE,0),row.names=NULL)
  filename  <-  paste0(dir.rawData, "/", newStudy, "/dataImportOptions.csv")
  if(!file.exists(filename)){
    write.csv(impo, paste0(dir.rawData, "/", newStudy, "/dataImportOptions.csv"),row.names=FALSE)
  }
}


#create the proper set of files in each folder
readNewFiles  <-  function(newStudy){
  # Load raw data from newStudy
  #
  # Args: 
  #   newStudy: folder where data is stored
  # 
  # Returns:
  #   dataframe
  
  #import options for data file
  import <-  read.csv(paste0(dir.rawData,"/",newStudy,"/dataImportOptions.csv"), 
                      h=FALSE, row.names=1, stringsAsFactors=FALSE)  
  
  #brings in the original .csv
  raw     <-  read.csv(paste0(dir.rawData,"/",newStudy,"/",import['name',]), 
                       h=(import['header',]=="TRUE"), 
                       skip=as.numeric(import['skip',]), 
                       stringsAsFactors=FALSE, strip.white=TRUE, check.names=FALSE)
  raw
}


setUpFiles  <-  function(newStudy){
  print(newStudy)
  
  #creates and writes dataManipulate.R
  cat("creates dataManipulate.R ")
  filename  <-  paste0(dir.rawData, "/", newStudy, "/dataManipulate.R")
  if(!file.exists(filename)){
    manip     <-  ""
    write(manip, paste0(dir.rawData,"/",newStudy,"/dataManipulate.R"))
  }  
  
  #creates dataMatchColumns.csv
  cat("creates dataMatchColumns.csv ")
  filename  <-  paste0(dir.rawData, "/", newStudy, "/dataMatchColumns.csv")
  if(!file.exists(filename)){
    
    #reads file accounting for dataImportOptions
    newFile   <-  readNewFiles(newStudy)
    
    matchCol  <-  data.frame(var_in=names(newFile), 
                             method=rep(NA,ncol(newFile)), 
                             unit_in=rep(NA,ncol(newFile)), 
                             var_out=rep(NA,ncol(newFile)), 
                             notes=rep(NA,ncol(newFile)), 
                             stringsAsFactors=FALSE)
    write.csv(matchCol, paste0(dir.rawData,"/",newStudy,"/dataMatchColumns.csv"), row.names=FALSE)
  }
  
  #creates and writes dataNew.csv
  cat("creates dataNew.csv ")
  filename  <-  paste0(dir.rawData, "/", newStudy, "/dataNew.csv")
  if(!file.exists(filename)){
    datnew  <-  data.frame(lookupVariable="",
                           lookupValue="",
                           newVariable="",
                           newValue="",
                           source="", 
                           stringsAsFactors=FALSE)
    datnew  <-  datnew[-1,]
    write.csv(datnew, paste0(dir.rawData,"/",newStudy,"/dataNew.csv"), row.names=FALSE)
  }
  
  #creates and writes studyContact.csv
  cat("creates studyContact.csv ")
  filename  <-  paste0(dir.rawData, "/", newStudy, "/studyContact.csv")
  if(!file.exists(filename)){
    contact  <-  data.frame(name=NA,
                            email=NA,
                            address=NA,
                            additional.info=NA,
                            stringsAsFactors=FALSE)
    write.csv(contact, paste0(dir.rawData,"/",newStudy,"/studyContact.csv"), row.names=FALSE)
  }
  
  #creates and writes studyMetadata.csv
  cat("creates studyMetadata.csv ")
  filename  <-  paste0(dir.rawData, "/", newStudy, "/studyMetadata.csv")
  if(!file.exists(filename)){
    metadat  <-  data.frame(Topic=c("Sampling strategy", "Leaf area", "Stem cross sectional area", "Height", "Crown area", "Biomass", "traits", "Growth environment", "Other variables"),
                            Description=c("Please provide a brief description of the sampling strategy used in this paper (up to 4 sentences)", rep("Please provide ...",8)),
                            stringsAsFactors=FALSE)    
    write(metadat, paste0(dir.rawData,"/",newStudy,"/studyMetadata.csv"))
  }
  
  #creates and writes studyRef.csv
  cat("creates studyRef.csv ")
  filename  <-  paste0(dir.rawData, "/", newStudy, "/studyRef.csv")
  if(!file.exists(filename)){
    sturef  <-  data.frame(reference="Missing",
                           stringsAsFactors=FALSE)
    write.csv(sturef, paste0(dir.rawData,"/",newStudy,"/studyRef.csv"), row.names=FALSE)
  }
}


addStudies<-function(studyNames, data=NULL, reprocess= FALSE, replace=FALSE, verbose=FALSE, browse=FALSE){
  # merge data from studyNames with existing 'data'    
  #
  # Args: 
  #   data: existing data
  #   reprocess: force data to be reprocessed
  #   replace: replace data from same dataset, if it exists
  #   verbose: print tsages to screen, good for isolating problems  
  #   browse: starts browser
  #
  # Returns:
  #   merged list with three parts: data, reference, contact
  
  N <- length(studyNames) #number of studies
  
  if (N>0){    
    #load data from each study as 
    d<-lapply(studyNames, loadStudy, reprocess=reprocess, verbose = verbose) 
    #merge data from each list into existing data
    for (i in 1:N)
      data<-addStudy(d[[i]], oldData=data, replace=replace)
  }
  data
}

loadStudy<-function(studyName, reprocess= FALSE, verbose=FALSE, browse=FALSE){
  # loads data from specified studyName
  #
  # Args: 
  #   studyName: name of folder where data stored
  #   reprocess: force data to be reprocessed
  #   verbose: print tsages to screen, good for isolating problems  
  #   browse: starts browser
  #
  # Returns:
  #   list with three parts: data, reference, contact
  
  if (verbose) cat(studyName, " ")
  
  #name of cleaned data file
  filename<-studyDataFile(studyName);
  
  #Check if cleaned datafile exists, if not create it
  if (!file.exists(filename) | reprocess)
    processStudy(studyName, verbose=verbose, browse=browse)
  
  study<-list()
  
  #Read cleaned data file
  study$data<-read.csv(filename, h= TRUE)
  
  #Read reference
  study$ref<-data.frame(dataset = studyName, read.csv(paste0(dir.rawData,"/",studyName,"/studyRef.csv"), h= TRUE, stringsAsFactors=FALSE, strip.white = TRUE))
  
  #Read contacts
  study$contact<-data.frame(dataset = studyName, read.csv(paste0(dir.rawData,"/",studyName,"/studyContact.csv"), h= TRUE, stringsAsFactors=FALSE, strip.white = TRUE ))
  
  study  
}

addStudy<-function(newData, oldData=NULL, replace=FALSE){
  # merge data from newData with oldData    
  #
  # Args: 
  #   newData: new data to be included
  #   replace: replace data from same dataset, if it exists
  #
  # Returns:
  #   merged list with three parts: data, reference, contact
  
  if (length(oldData)==0) {
    return(newData)
  } else {
    for(var in c("data", "ref", "contact"))
      oldData[[var]]<-Rbind(oldData[[var]], newData[[var]], replace=replace)
    return(oldData)
  }
}


Rbind<-function(dfr1, dfr2, checkColumn = "dataset", add=FALSE, replace=FALSE){
  # Binds two dataframes togther
  #
  # Args: 
  #   dfr1: first dataframe
  #   dfr2: second dataframe
  #   checkColumn: checks for matches between drf1 and dfr2 in a column with this name
  #   add: add new instances of checkColumn, even if they already exist
  #   replace: replace instances of checkColumn if they already exist
  # 
  # Returns:
  #   merged dataframe
  
  #check column names match, if not print an error
  if (any(names(dfr1) != names(dfr2))){
    cat("Column names do not match in rbind\n\n")
    cat(names(dfr1), "\n\n", names(dfr2), "\n\n", names(dfr1) == names(dfr2), "\n\n")
  }
  
  #check data does not already exist
  if (!replace & !add & any(dfr1[, checkColumn] %in% dfr2[, checkColumn]))
    stop("Attempting to add data when allready exists for ", checkColumn)
  
  #Remove existing data if required
  if (replace)
    dfr1<-dfr1[!(dfr1[, checkColumn] %in% dfr2[, checkColumn]),]
  
  rbind(dfr1, dfr2)    
}

processStudy<-function(studyName, verbose=FALSE, browse=FALSE){
  # Processes raw data from studyName, for incorporation into main dataset.
  # Fixes column names, variable names, imports new data, makes standard dataframe
  #
  # Args: 
  # 
  # Returns:
  #     transformed data savef in file output/data/studyName.csv
  
  if (verbose) cat(studyName, " ")
  
  #delete existing output file, if exists
  outputName<-studyDataFile(studyName)
  if (file.exists(outputName)) file.remove(outputName)  
  
  #call browser if required
  if (browse) browser()
  
  #read original data from file
  if (verbose) cat("load data ")
  raw<-readRawData(studyName) 
  
  #Manipulate data where needed
  if (verbose)  cat("manipulate data ")
  filename<-paste0(dir.rawData,"/",studyName,"/dataManipulate.R")
  if (file.exists(filename))
    source(filename, local=TRUE)
  
  #add studyname to dataset
  data<-raw
  data$dataset=studyName
  
  #convert units and variable names, add methods variables
  if (verbose) cat("convert units ")
  data<-convertData(studyName, data)
  
  #Remove / add columns to mirror those in final database
  if (verbose) cat("add/remove columns ")
  data<-addAllColumns(data)
  
  #import new data, if available
  if (verbose) cat("import new data ")
  data<-addNewData(studyName, data)
  
  #write data to file
  if (verbose) cat("write to file ")
  write.csv(data, outputName, row.names=FALSE)
}

readRawData<-function(studyName){
  # Load raw data from studyName
  #
  # Args: 
  #   studyName: folder where data is stored
  # 
  # Returns:
  #   dataframe
  
  #import options for data file
  import <-  read.csv(paste0(dir.rawData,"/",studyName,"/dataImportOptions.csv"), 
                      h=FALSE, row.names=1, stringsAsFactors=FALSE, strip.white=TRUE)   
  
  # Specify na.strings, optional
  if("na.strings" %in% rownames(import)){
    nastr <- import['na.strings',]
    # make na.strings numeric if it looks like it should be
    if(!is.na(as.numeric(nastr)))nastr <- as.numeric(nastr)
    nastr <- c(NA,nastr) # and add NA, the default missing string.    
  } else
    nastr <- NA
  
  #allow custom fileEncoding if specified, optional
  if("fileEncoding" %in% rownames(import)){
    fileEncoding <- as.character(import['fileEncoding',])    
  } else {
    fileEncoding <- ""  #default 
  }
  
  #read in the original .csv
  raw     <-  read.csv(paste0(dir.rawData,"/",studyName,"/",import['name',]), 
                       h=(import['header',]=="TRUE"), 
                       skip=as.numeric(import['skip',]), 
                       na.strings=nastr, check.names=FALSE,
                       stringsAsFactors=FALSE, strip.white=TRUE, 
                       fileEncoding =fileEncoding)
  raw
}

addAllColumns<-function(data){
  # Add/removes columns of data so that they match those in 
  # standrad template for study
  #
  # Returns:
  #   dataframe
  
  allowedNames<-var.def$Variable  #allowed names
  type<-var.def$Type  #variable type: charcater / numeric
  
  
  #Expand list to include "methods" variables, where appropriate
  allowedNames<-c(allowedNames, as.character(paste("method_", var.def$Variable[var.def$methodsVariable], sep=""))) 
  type<-c(type, rep("character",sum(var.def$methodsVariable)))  #all methods have type "character"
  
  #remove columns not in allowed list
  data<-data[,(names(data)%in%allowedNames)]  
  
  #add columns missing from final list
  present<- (allowedNames %in% names(data)) #check if already present
  for (i in 1:length(allowedNames))
    if (!present[i]){  #variable not present, add
      data[,allowedNames[i]] = NA
      class(data[,allowedNames[i]])<-type[i]
    }  
  data[,allowedNames] #return in desired order
}

addNewData<-function(studyName, data){
  # Modifies data by adding new values from table studyName/dataNew.csv. 
  # Applies newValues in newVariable to all matches for lookupValue in lookupVariable. 
  # Applies to entire dataset when lookupValue == NA
  #
  # Args: 
  #   data: existing data frame
  # 
  # Returns:
  #   modified data frame
  
  filename<-paste0(dir.rawData,"/",studyName,"/dataNew.csv") #name of data file
  
  if (file.exists(filename)){ #open if it exists
    import <-  read.csv(filename, h=TRUE, stringsAsFactors=FALSE, strip.white = TRUE) #read in new data    
    
    nchanges<- length(import$lookupVariable) #count number of changes required
    if (nchanges>0){
      
      nameIsOK<-import$newVariable %in% var.def$Variable #Check name is allowed
      if (any(!nameIsOK)) 
        stop("Incorrect name in var_out columns of dataMatchColumns.csv for ", studyName, "--> ", import$newVariable[!nameIsOK])
      
      for (i in 1:nchanges){     #make changes one by one
        if (is.na(import$lookupVariable[i]) | import$lookupVariable[i] =="") #apply to whole column
          data[,import$newVariable[i]] = import$newValue[i]
        else  #apply to subset
          data[data[,import$lookupVariable[i] ]==import$lookupValue[i],import$newVariable[i] ] = import$newValue[i]
      }   
    }      
  }
  data
}

convertData<-function(studyName,data){
  #convert data to desired format, changing units, variable names
  #
  # Args: 
  #   data: existing data frame
  # 
  # Returns:
  #   modified data frame
  
  #load variable matching table
  var.match <- read.csv(paste0(dir.rawData,"/",studyName,"/dataMatchColumns.csv"),h=TRUE,stringsAsFactors=FALSE,na.strings=c("NA",""))
  
  #Check all names in table are allowed
  nameIsOK<-var.match$var_out[!is.na(var.match$var_out)] %in% var.def$Variable
  if (any(!nameIsOK))
    stop("Incorrect name in var_out columns of dataMatchColumns.csv for ", studyName, "--> ", var.match$var_out[!nameIsOK])
  
  #Find the column numbers in the data that need to be checked out for conversion, only check columns 
  selec  <-  match(names(data), var.match$var_in[!is.na(var.match$var_out)]) 
  for(a in selec[!is.na(selec)]){    #Do for every column that needs conversion
    a  <-  which(selec==a)
    #rename variables
    var.in   <-  names(data)[a] #variable that goes in
    var.out  <-  var.match$var_out[var.match$var_in==var.in & !is.na(var.match$var_in)] #variable that goes out   
    names(data)[a] <-  var.out #resets the name of a particular variable to the standardised form
    
    #change units, only for numeric variables 
    if(var.def$Type[var.def$Variable==var.out] == "numeric"){
      un.in    <-  var.match$unit_in[var.match$var_in==var.in] #unit that goes in
      if(is.na(un.in))
        stop("unit missing for variable ", var.in, " in ", studyName)
      un.out   <-  var.def$Units[var.def$Variable==var.out] #unit that goes out
    
    if(un.in != un.out){ # check if units differ
      func     <-  get(paste(un.in, ".", un.out, sep="")) #select the function based on variables
      data[,a] <-  func(as.numeric(data[,a])) #applies the function to the column
    }
    }
    
    #add methods varaibles
    met.in   <-  var.match$method[var.match$var_in==var.in] #method used to measure
    
    if (!is.na(met.in)){ # 
      data$NEW                 <-  rep(met.in, nrow(data)) #creates a new colum that contains the method description
      names(data)[ncol(data)]  <-  paste("method", "_", var.out, sep="") #changes the names by pasting "method" and the standardised variable name 
    }
  }
  data
}


#Paste together list of varNames and their values, used for aggregating varnames into "grouping" variable
makeGroups <-function(data, varNames){
  
  #if name does not exist stop with error message
  checkNameExists<-!(varNames %in% names(data))
  if(any(checkNameExists))
    stop(paste("Variable ", varNames[checkNameExists], " not found, called in dataManipulate.R"))
 
  apply(cbind(data[,varNames]), 1, function(x)paste(varNames,"=",x,collapse="; "))  
}

#creates name of file to store processed data
studyDataFile<-function(studyName){
  paste0(dir.cleanData,"/", studyName, ".csv", sep="")
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
