library(bibtex, quietly=TRUE)


if("dataMashR" %in% .packages()){
  library(dataMashR)  
} else {
  library(devtools)
  install_github("dataMashR","dfalster")
  library(dataMashR)
}

#set directories for study
dir.rawData   <-  "data" 
dir.cleanData <-  "output/data"
var.def       <-  read.csv("config/variableDefinitions.csv", h=TRUE, stringsAsFactors=FALSE)#variable definitions
met.def       <-  read.csv("config/methodsDefinitions.csv", h=TRUE, stringsAsFactors=FALSE)#definition of methods


#::: Everything below was moved to dataMashR
# 
# # Get list of studies included in database
# getStudyNames <-function(){
#   dir(dir.rawData)
# }
# 
# 
# 
# #' Adds studies to the central dataset
# #'
# #' @param studyNames Character vector of study names to be added
# #' @param data If provided, will add studies to this dataframe
# #' @param reprocess If TRUE, will reprocess studies even if they already exist in the data directory
# #' @param verbose If TRUE, print messages to screen, good for isolating problems  
# #' @return merged list with three parts: data, reference, contact,
# #'    each is a dataframe with all data combined.
# #' @keywords misc
# #' @export
# loadStudies <- function(studyNames=getStudyNames(), data=NULL,
#                         reprocess=FALSE, verbose=FALSE) {
#   d <- lapply(studyNames, loadStudy, reprocess=reprocess,
#               verbose=verbose)
#   vars <- c("data", "ref", "contact")
#   f <- function(v)
#     do.call(rbind, lapply(d, "[[", v))
#   structure(lapply(vars, f), names=vars)
# }
# 
# ##' Load data from specified studyName
# ##'
# ##' @param studyName: name of folder where data stored
# ##' @param reprocess: force data to be reprocessed
# ##' @param verbose: print tsages to screen, good for isolating problems  
# ##' @return list with three parts: data, reference, contact
# ##' @export
# loadStudy <- function(studyName, reprocess=FALSE, verbose=FALSE) {
#   if (verbose)
#     cat(studyName, " ")
# 
#   list(data=readDataProcessed(studyName, reprocess),
#        ref=readReference(studyName),
#        contact=readContact(studyName))
# }
# 
# readDataProcessed <- function(studyName, reprocess=TRUE) {
#   filename <- studyDataFile(studyName)
#   if ( reprocess || !file.exists(filename) )
#     processStudy(studyName)
#   else
#     read.csv(filename, header=TRUE, stringsAsFactors=FALSE)
# }
# 
# ## TODO: Roxygenise(?)
# # Processes raw data from studyName, for incorporation into main dataset.
# # Fixes column names, variable names, imports new data, makes standard dataframe
# #
# # Args: 
# # 
# # Returns:
# #     transformed data saved in file output/data/studyName.csv
# processStudy <- function(studyName, verbose=FALSE) {
# 
#   if (verbose) cat(studyName, " ")
# 
#   outputName <- studyDataFile(studyName)
#   
#   if (verbose) cat("load data\n")
#   data <- readDataRaw(studyName)
#   
#   if (verbose) cat("manipulate data\n")
#   data <- manipulateData(studyName, data)
#   
#   data$dataset <- studyName
#   
#   #convert units and variable names, add methods variables
#   if (verbose) cat("convert units\n")
#   data <- convertData(studyName, data)
#   
#   #Remove / add columns to mirror those in final database
#   if (verbose) cat("add/remove columns\n")
#   data <- addAllColumns(data)
#   
#   if (verbose) cat("import new data \n")
#   data <- addNewData(studyName, data)
#   
#   if (verbose) cat("write to file\n")
#   
#   ## Creates output directory if does not already exist 
#   if(!file.exists(dir.cleanData))
#     dir.create(dir.cleanData, recursive=TRUE)  
#   write.csv(data, outputName, row.names=FALSE)
# 
#   data
# }
# 
# ##' Load raw data from studyName
# ##'
# ##' @param studyName folder where data is stored
# ##' @return dataframe with raw data
# readDataRaw<-function(studyName){
#   import <- readImport(studyName)
#   
#   read.csv(data.path(studyName, import$name),
#            header=import$header, skip=import$skip,
#            na.strings=import$na.strings, check.names=FALSE,
#            stringsAsFactors=FALSE, strip.white=TRUE)
# }
# 
# 
# 
# 
# 
# ##' Perform arbitrary manipulations to the raw data
# ##'
# ##' @param studyName folder where data is stored
# ##' @param data raw data, as from readDataRaw
# ##' @return data.frame, with manipulations carried out
# manipulateData <- function(studyName, data) {
#   manipulate <- getManipulateData(studyName)
#   manipulate(data)
# }
# 
# ##' Load the data manipulation function, if present
# ##'
# ##' If the `dataManipulate.R` file is present within a study's data
# ##' directory, it must contain the function `manipulate`.  Otherwise
# ##' we return the identity function to indicate no manipulations will
# ##' be done.  The function must take a data.frame as an argument and
# ##' return one as the return value, but this is not checked at
# ##' present.
# ##'
# ##' @param studyName folder where data is stored
# ##' @return function for manipulating a data.frame
# getManipulateData <- function(studyName) {
#   filename <- data.path(studyName, "dataManipulate.R")
#   if (file.exists(filename)) {
#     e <- new.env()
#     source(filename, local=e)
#     if ( !exists("manipulate", envir=e) )
#       stop("Expected function 'manipulate' within dataManipulate.R")
#     match.fun(e$manipulate)
#   } else {
#     identity
#   }
# }
# 
# ##' Convert data to desired format, changing units, variable names
# ##' 
# ##' @param data existing data frame
# ##' @return modified data frame
# convertData <- function(studyName, data){
#   var.match <- readMatchColumns(studyName)
#   info <- columnInfo()
# 
#   data <- rename(data, var.match$var_in, var.match$var_out)
# 
#   for ( col in intersect(names(data), var.match$var_out) ) {
#     idx <- match(col, var.match$var_out)[[1]]
#     if (info$type[[col]] == "numeric" ) {
#       unit.from <- var.match$unit_in[idx]
#       unit.to   <- info$units[[col]]
#       data[[col]] <- transform(data[[col]], unit.from, unit.to)
#     }
# 
#     method <- var.match$method[idx]
#     if ( !is.na(method) )
#       data[[paste("method", col, sep="_")]] <- method
#   }
# 
#   data
# }
# 
# ##' Standardise data columns to match standard template.
# ##'
# ##' May add or remove columns of data as needed so that all sets have
# ##' the same columns.
# ##'
# ##' @param data data.frame, after being run through convertData
# ##' @return data.frame
# addAllColumns <- function(data) {
#   info <- columnInfo()
#   missing <- setdiff(info$allowedNames, names(data))
#   missing.df <-
#     as.data.frame(lapply(info$type[missing], na.vector, nrow(data)),
#                   stringsAsFactors=FALSE)
#   data <- cbind(data[names(data) %in% info$allowedNames], missing.df)
#   data[info$allowedNames]
# }
# 
# ##' Modifies data by adding new values from table studyName/dataNew.csv
# ##'
# ##' Within the column given by 'newVariable', replace values that
# ##' match 'lookupValue' within column 'lookupVariable' with the value
# ##' newValue'.  If 'lookupVariable' is NA, then replace *all* elements
# ##' of 'newVariable' with the value 'newValue'.
# ##'
# ##' Note that lookupVariable can be the same as newVariable.
# ##'
# ##' @param data existing data.frame (from addAllColumns)
# ##' @return modified data.frame
# addNewData <- function(studyName, data) {
#   import <- readNewData(studyName)
#   
#   if ( !is.null(import) ) {
#     for (i in seq_len(nrow(import))) {
#       col.to <- import$newVariable[i]
#       col.from <- import$lookupVariable[i]
#       if (is.na(col.from)) { # apply to whole column
#         data[col.to] <- import$newValue[i]
#       } else {
#         ## apply to subset
#         rows <- data[[col.from]] == import$lookupValue[i]
#         data[rows,col.to] <- import$newValue[i]
#       }
#     }   
#   }      
#   data
# }
# 
# ##' Utility function to read/process dataNew.csv for addNewData
# readNewData <- function(studyName) {
#   filename <- data.path(studyName, "dataNew.csv")
#   if ( file.exists(filename) ) {
#     import <- read.csv(filename, header=TRUE, stringsAsFactors=FALSE,
#                        strip.white=TRUE)
#     if ( nrow(import) > 0 ) {
#       import$lookupVariable[import$lookupVariable == ""] <- NA
#       nameIsOK <- import$newVariable %in% var.def$Variable
#       if (any(!nameIsOK)) 
#         stop("Incorrect name in var_out columns of dataMatchColumns.csv for ",
#              studyName, "--> ", paste(import$newVariable[!nameIsOK],
#                                       collapse=", "))
#     } else {
#       import <- NULL
#     }
#   } else {
#     import <- NULL
#   }
#   import
# }
# 
# 
# ## * Functions for creating the import directory structure for new
# ## * data.  Not reviewed yet.
# 
# #first create a dataImportOptions.csv for each new study
# makeDataImport  <-  function(newStudy){
#   impo      <-  data.frame(name=c("header","skip"),data.csv=c(TRUE,0),row.names=NULL)
#   filename  <-  paste0(dir.rawData, "/", newStudy, "/dataImportOptions.csv")
#   if(!file.exists(filename)){
#     write.csv(impo, paste0(dir.rawData, "/", newStudy, "/dataImportOptions.csv"),row.names=FALSE)
#   }
# }
# 
# #' Create the proper set of files in each folder
# #' 
# #' @param newStudy folder where data is stored
# #' @return a dataframe
# #' @export
# #' @keywords misc
# readNewFiles  <-  function(newStudy){
#   # Load raw data from newStudy
#   #
#   # Args: 
#   #   newStudy: folder where data is stored
#   # 
#   # Returns:
#   #   dataframe
#   
#   #import options for data file
#   import <-  read.csv(paste0(dir.rawData,"/",newStudy,"/dataImportOptions.csv"), 
#                       h=FALSE, row.names=1, stringsAsFactors=FALSE)  
#   
#   #brings in the original .csv
#   raw     <-  read.csv(paste0(dir.rawData,"/",newStudy,"/",import['name',]), 
#                        h=(import['header',]=="TRUE"), 
#                        skip=as.numeric(import['skip',]), 
#                        stringsAsFactors=FALSE, strip.white=TRUE, check.names=FALSE)
#   raw
# }
# 
# ##' Sets up files for new study to be added to the database
# ##' 
# ##' @param newStudy Name of the directory that is to be added
# ##' @param quiet If TRUE, don't print messages about progress
# ##' @return Nothing; directories are created
# ##' @export
# setUpFiles  <-  function(newStudy, quiet=FALSE){
#   if(!quiet)message("Setting up files for ", newStudy)
#   
#   #creates and writes dataManipulate.R
#   if(!quiet)message("creates dataManipulate.R")
#   filename  <-  paste0(dir.rawData, "/", newStudy, "/dataManipulate.R")
#   if(!file.exists(filename)){
#     manip     <-  ""
#     write(manip, paste0(dir.rawData,"/",newStudy,"/dataManipulate.R"))
#   }  
#   
#   #creates dataMatchColumns.csv
#   if(!quiet)message("creates dataMatchColumns.csv")
#   filename  <-  paste0(dir.rawData, "/", newStudy, "/dataMatchColumns.csv")
#   if(!file.exists(filename)){
#     
#     #reads file accounting for dataImportOptions
#     newFile   <-  readNewFiles(newStudy)
#     
#     matchCol  <-  data.frame(var_in=names(newFile), 
#                              method=rep(NA,ncol(newFile)), 
#                              unit_in=rep(NA,ncol(newFile)), 
#                              var_out=rep(NA,ncol(newFile)), 
#                              notes=rep(NA,ncol(newFile)), 
#                              stringsAsFactors=FALSE)
#     write.csv(matchCol, paste0(dir.rawData,"/",newStudy,"/dataMatchColumns.csv"), row.names=FALSE)
#   }
#   
#   #creates and writes dataNew.csv
#   if(!quiet)message("creates dataNew.csv")
#   filename  <-  paste0(dir.rawData, "/", newStudy, "/dataNew.csv")
#   if(!file.exists(filename)){
#     datnew  <-  data.frame(lookupVariable="",
#                            lookupValue="",
#                            newVariable="",
#                            newValue="",
#                            source="", 
#                            stringsAsFactors=FALSE)
#     datnew  <-  datnew[-1,]
#     write.csv(datnew, paste0(dir.rawData,"/",newStudy,"/dataNew.csv"), row.names=FALSE)
#   }
#   
#   #creates and writes studyContact.csv
#   if(!quiet)message("creates studyContact.csv")
#   filename  <-  paste0(dir.rawData, "/", newStudy, "/studyContact.csv")
#   if(!file.exists(filename)){
#     contact  <-  data.frame(name=NA,
#                             email=NA,
#                             address=NA,
#                             additional.info=NA,
#                             stringsAsFactors=FALSE)
#     write.csv(contact, paste0(dir.rawData,"/",newStudy,"/studyContact.csv"), row.names=FALSE)
#   }
#   
#   
#   
#   #creates and writes studyMetadata.csv
#   if(!quiet)cat("creates studyMetadata.csv ")
#   filename  <-  paste0(dir.rawData, "/", newStudy, "/studyMetadata.csv")
#   if(!file.exists(filename)){
#     metadat  <-  data.frame(Topic=c("Sampling strategy", "Leaf area", "Stem cross sectional area", "Height", "Crown area", "Biomass", "traits", "Growth environment", "Other variables"),
#                             Description=c("Please provide a brief description of the sampling strategy used in this paper (up to 4 sentences)", rep("Please provide ...",8)),
#                             stringsAsFactors=FALSE)    
#     write.csv(metadat, paste0(dir.rawData,"/",newStudy,"/studyMetadata.csv"))
#   }
#   
#   #creates and writes studyRef.csv
#   if(!quiet)cat("creates studyRef.csv ")
#   filename  <-  paste0(dir.rawData, "/", newStudy, "/studyRef.csv")
#   if(!file.exists(filename)){
#     sturef  <-  data.frame(reference="Missing",
#                            stringsAsFactors=FALSE)
#     write.csv(sturef, paste0(dir.rawData,"/",newStudy,"/studyRef.csv"), row.names=FALSE)
#   }
# }
# 
# readMatchColumns <- function(studyName) {
#   filename <- file.path(dir.rawData, studyName, "dataMatchColumns.csv")
#   var.match <- read.csv(filename, header=TRUE, stringsAsFactors=FALSE,
#                         na.strings=c("NA", ""), strip.white=TRUE)
# 
#   ## TODO: var.def is global
#   nameIsOK <- (var.match$var_out[!is.na(var.match$var_out)] %in%
#                var.def$Variable)
#   if (any(!nameIsOK))
#     
#     stop("Incorrect name in var_out columns of dataMatchColumns.csv for ",
#          studyName, "--> ",
#          paste(var.match$var_out[!nameIsOK], collapse=", "))
# 
#   if ( any(is.na(var.match$var_in)) ) {
#     warning("Pruning empty columns from", studyName)
#     var.match <- var.match[!is.na(var.match$var_in),]
#   }
# 
#   if ( any(duplicated(na.omit(var.match$var_out))) ) {
#     dups <- na.omit(unique(var.match$var_out[duplicated(var.match$var_out)]))
#     warning(sprintf("Duplicated output columns in %s: %s",
#                     studyName, paste(dups, collapse=", ")))
#   }
#   
#   var.match[!is.na(var.match$var_out),]
# }
# 
# #Paste together list of varNames and their values, used for
# #aggregating varnames into "grouping" variable
# ## NOTE: Used in dataManipulate.R
# makeGroups <-function(data, varNames){
#   
#   #if name does not exist stop with error message
#   checkNameExists<-!(varNames %in% names(data))
#   if(any(checkNameExists))
#     stop(paste("Variable ", varNames[checkNameExists], " not found, called in dataManipulate.R"))
#  
#   apply(cbind(data[,varNames]), 1, function(x)paste(varNames,"=",x,collapse="; "))  
# }
# 
# #creates name of file to store processed data
# studyDataFile <- function(studyName) {
#   file.path(dir.cleanData, paste0(studyName, ".csv"))
# }
# 
# readImport <- function(studyName) {
#   filename <- file.path(dir.rawData, studyName, "dataImportOptions.csv")
#   if (!file.exists(filename))
#     stop(sprintf("Import options file does not exist (expected at %s)",
#                  filename))
#   tmp <- read.csv(filename, header=FALSE, row.names=1,
#                   stringsAsFactors=FALSE)
# 
#   defaults <- list(na.strings="NA")
#   import <- modifyList(defaults,
#                        structure(as.list(tmp[[1]]), names=rownames(tmp)))
#   import$header <- as.logical(import$header)
#   import$skip <- as.integer(import$skip)
#   if ( !("NA" %in% import$na.strings) )
#     import$na.strings <- c("NA", import$na.strings)
#   import
# }
# 
# getContributors<-function(data){  
#   data$contact[!duplicated(d$contact$name),]
# }
# 
# extractStudy<-function(alldata, study){
#   for(var in c("data", "ref", "contact"))
#     alldata[[var]]<-alldata[[var]][alldata[[var]]$dataset == study,]
#   alldata  
# }
# 
# 
# #Conversion functions - converts unit before the dot into the unit after it
# g.kg             <-  function(x){x/1000} #from g to kg
# mg.kg            <-  function(x){x/1000000} #from mg to kg
# cm2.m2           <-  function(x){x/10000} #from cm2 to m2
# cm.m             <-  function(x){x/100} #from cm to m
# mm.m             <-  function(x){x/1000} #from mm to m
# months.yr        <-  function(x){x/12} #from months to yr
# g.cm2.kg.m2      <-  function(x){x*10} #from g/cm2 to kg/m2
# m2.kg.kg.m2      <-  function(x){1/x} #from m2/kg to kg/m2
# cm2.g.kg.m2      <-  function(x){1/x*10} #from cm2/g to kg/m2
# g.m2.kg.m2       <-  function(x){x/1000} #from g/m2 to kg/m2
# g.cm3.kg.m3      <-  function(x){x*1000} #from g/cm3 to kg/cm3
# per.kg.kg        <-  function(x){x/100} #from percentage to decimals
# mm2.m2           <-  function(x){x/(10^6)} #from mm2 to m2
# cm2.kg.kg.m2     <-  function(x){1000/x} #from cm2/kg to kg/m2
# mmol.N.kg.kg.kg  <-  function(x){x*14e-6} #from mmol of nitrogen/kg to kg/kg
# Mg.kg            <-  function(x){x/1000} #from megagrams (Mg) to kg
# g.l.kg.m3        <-  function(x){x} #from grams/litre to kg/m3
# kg.l.kg.m3       <-  function(x){x*1000} #from kilograms/litre to kg/m3
# g.g.kg.kg        <-  function(x){x} #stays the same  
# 
# data.path <- function(studyName, ...){
#   file.path(dir.rawData, studyName, ...)  
# }
# 
# readReference <- function(studyName) {
#   filename <-data.path(studyName, "studyRef.bib")
#   myBib <- read.bib(filename)  
#   
#   if(is.null(myBib$doi)) myBib$doi <-""  
#   
#   if(myBib$doi != "") myBib$url <- paste0("http://dx.doi.org/", myBib$doi)
#   if(is.null(myBib$url)) myBib$url <-""  
#   
#   data.frame(dataset=studyName, filename,  doi = myBib$doi, url= myBib$url, stringsAsFactors=FALSE)
# }
# 
# readContact <- function(studyName) {
#   filename <-data.path(studyName, "studyContact.csv")
#   
#   contact <- read.csv( filename,
#                       header=TRUE, stringsAsFactors=FALSE,
#                       strip.white=TRUE)
#   data.frame(dataset = studyName, contact, filename,  stringsAsFactors=FALSE)
# }
# 
# na.vector <- function(type, n) {
#   x <- switch(type,
#               character=NA_character_,
#               numeric=NA_real_,
#               stop("Unknown type", type))
#   rep.int(x, n)
# }
# 
# 
# # Subset of dataframe, removing all columns that are NA only.
# nonNA <- function(df)df[,sapply(df, function(x)!all(is.na(x)))]
# 
# 
# ## TODO: This might merge somewhat with the definition of var.def.
# columnInfo <- function() {
#   allowedNames <- var.def$Variable
#   type <- var.def$Type # variable type: charcater / numeric
#   ##Expand list to include "methods" variables, where appropriate
#   methods <- paste0("method_", var.def$Variable[var.def$methodsVariable])
#   allowedNames <- c(allowedNames, methods)
#   type <- c(type, rep("character", length(methods)))
#   names(type) <- allowedNames
#   units <- structure(var.def$Units, names=var.def$Variable)
#   list(allowedNames=allowedNames,
#        type=type,
#        units=units)
# }
# 
# is.blank <- function(x)
#   is.na(x) | x == ""
# 
# rename <- function(obj, names.from, names.to) {
#   if ( length(names.from) != length(names.to) )
#     stop("names.from and names.to must be the same length")
#   i <- match(names.from, names(obj))
#   if ( any(is.na(i)) )
#     stop(paste("Could not find names", paste(names.from[is.na(i)], collapse=", ")))
#   names(obj)[i] <- names.to
#   obj
# }
# 
# transform <- function(x, unit.from, unit.to) {
#   if (unit.from != unit.to)
#     x <- match.fun(paste(unit.from, unit.to, sep="."))(x)
#   x
# }
# 
# 
# changeVars <-  function(studyNames=getStudyNames(), from, to, path=dir.rawData){
#   
#   lapply(studyNames, changeVarsInFolder, from=from, to=to, path=path)
#   changeVarCsv(filename="variableDefinitions", column="Variable", from=from, to=to, path="config")
#   
# }
# 
# changeVarsInFolder  <-  function(study, from, to, path=dir.rawData){
#   changeVarCsv(study, from=from, to=to, filename="dataMatchColumns", column="var_out", path=path)
#   changeVarCsv(study, from=from, to=to, filename="dataNew", column="newVariable", path=path)
#   changeVarR(study, from=from, to=to, filename="dataManipulate", path=path)
# }
# 
# changeVarCsv  <-  function(study, filename, column, from, to, path=dir.rawData){
#   if(missing(study)){
#     x  <-  read.csv(paste0(path, "/", filename, ".csv"), h=TRUE, stringsAsFactors=FALSE)
#   } else {
#     x  <-  read.csv(paste0(path, "/", study, "/", filename, ".csv"), h=TRUE, stringsAsFactors=FALSE)
#   }
#   if(length(x[[column]][x[[column]] %in% from]) > 0){
#     x[[column]][x[[column]]==from]  <-  to
#     if(missing(study)){
#       write.csv(x, paste0(path, "/", filename, ".csv"), row.names=FALSE)
#     } else {
#       write.csv(x, paste0(path, "/", study, "/", filename, ".csv"), row.names=FALSE)
#     }
#   }
# }  
#   
# changeVarR  <-  function(study, filename, from, to, path=dir.rawData){  
#     File  <-  paste0(path, "/", study, "/", filename, ".R")
#     
#     from <- paste0('"',from,'"')
#     to <- paste0('"',to,'"')
#     
#     if(file.exists(File)){
#       x     <-  readChar(File, file.info(File)$size)
#       if(length(grep(from, x)) > 0){
#         x  <-  gsub(from, to, x)
#         write(x, File)
#       }          
#     }
# }
# 
