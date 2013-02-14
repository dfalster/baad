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
  new<-loadDataOrig(studyName) 
  
  #convert units and variable names
  data<-convertDataOrig(new)

  #write data to file  
  writeDataOrig(data)
  
  data
}

#Define a function for that constructs dataframe for this study
#NOTE - this is just a template. this function is redfined for each study 
# See file makeDataFrame.R stored in its each studies directory
makeDataFrame<-function(raw, studyName){
  data  <-  NULL
}

#write data to file
writeDataOrig<-function(data, name= data$dataset[1]){
  write.csv(data, paste0(dir.cleanData,"/", name, ".csv", sep=""), row.names=FALSE)
}

#convert data to desired format, changing units, variable names
convertDataOrig<-function(data){

  match  <-  var.match[var.match$reference==unique(data$dataset),] #Filters for a specific study, one at a time or each loop step

  selec  <-  which(names(data) %in% match$var_in) #Find the column numbers in the data that need to be checked out for conversion

for(j in 1:length(selec)){    #Do for every column that needs conversion
  a        <-  selec[j]
  var.in   <-  names(data)[a] #variable that goes in
  met.in   <-  match$method[match$var_in==var.in] #method used to measure
  un.in    <-  match$unit_in[match$var_in==var.in] #unit that goes in
  var.out  <-  match$var_out[match$var_in==var.in] #variable that goes out   
  un.out   <-  var.def$Units[var.def$Variable==var.out] #unit that goes out
  
  if(un.in != un.out){
    func     <-  get(paste(un.in, ".", un.out, sep="")) #select the function based on variables
    data[,a] <-  func(as.numeric(data[,a])) #applies the function to the column
  }
  
  names(data)[a] <-  var.out #resets the name of a particular variable to the standardised form
  
  if(met.in != ""){ # 
    if(length(unlist(strsplit(met.in, ",")))==1){
      method                   <-  met.def$definition[met.def$method==met.in] #matches the full descrition of the method based on its code
      data$NEW                 <-  rep(method, nrow(data)) #creates a new colum that contains the method description
      names(data)[ncol(data)]  <-  paste("method", "_", var.out, sep="") #changes the names by pasting "method" and the standardised variable name 
      data                     <-  data[,c(1:a, ncol(data), (a+1):(ncol(data)-1))] #puts the method beside its variable
      selec                    <-  selec+1 #update the counter
    } else {
      method  <-  vector()
      for(z in 2:length(unlist(strsplit(met.in, ",")))){
        method  <-  paste(method, " | ", met.def$definition[met.def$method==unlist(strsplit(met.in, ","))[z]], sep="")
      }
      
      method  <-  substr(method, 4, length(unlist(strsplit(method, ""))))
      
      data$NEW                 <-  rep(method, nrow(data)) #creates a new colum that contains the method description
      names(data)[ncol(data)]  <-  paste("method", "_", var.out, sep="") #changes the names by pasting "method" and the standardised variable name 
      data                     <-  data[,c(1:a, ncol(data), (a+1):(ncol(data)-1))] #puts the method beside its variable
      selec                    <-  selec+1 #update the counter
    }
  }
}
data
}

loadStudyData<-function(studyName){
  #import options for data file
  import <-  read.csv(paste0(dir.rawData,"/",studyName,"/import.csv"), h=FALSE, row.names=1, stringsAsFactors=FALSE) #loads import options for study
  #brings in the original .csv
  dat     <-  read.csv(paste0(dir.rawData,"/",studyName,"/",import['name',]), h=(import['header',]=="TRUE"), skip=as.numeric(import['skip',]), stringsAsFactors=FALSE)
}

loadDataOrig<-function(studyName){
  raw<-loadStudyData(studyName)
  source(paste0(dir.rawData,"/",studyName,"/makeDataFrame.R"))
  #TODO: change c(3:12, 14:37, 39:45) to something more robust, e.g. colnames
  data<-makeDataFrame(raw, studyName)
}

