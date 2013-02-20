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
  new<-loadData(studyName) 
  
  #convert units and variable names
  data<-convertData(new, studyName)

  #write data to file  
  writeData(data)
  
  data
}

loadData<-function(studyName){
  #import options for data file
  import <-  read.csv(paste0(dir.rawData,"/",studyName,"/import.csv"), h=FALSE, row.names=1, stringsAsFactors=FALSE) #loads import options for study
  #brings in the original .csv
  raw     <-  read.csv(paste0(dir.rawData,"/",studyName,"/",import['name',]), h=(import['header',]=="TRUE"), skip=as.numeric(import['skip',]), stringsAsFactors=FALSE)
  
  source(paste0(dir.rawData,"/",studyName,"/makeDataFrame.R"))
  #TODO: change c(3:12, 14:37, 39:45) to something more robust, e.g. colnames
  data<-makeDataFrame(raw, studyName)
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
  var.match <- read.csv("R/variable_match.csv", h=TRUE, stringsAsFactors=FALSE)#variable match for each study
  var.match <- var.match[var.match$reference==studyName,] #Filters for a specific study, one at a time or each loop step
  
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
  
  if(met.in != ""){ # 
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
