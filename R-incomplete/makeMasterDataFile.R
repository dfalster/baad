#make names lowercase
lownames <- function(x)tolower(names(x))

#Set base dir
base.dir<-"~/Dropbox/Documents/_research/Falster-Allometry/baad/"
#base.dir<-"/Users/barneche/Dropbox/Daniel_datasets/"

#load clean data files
dir.rawData   <-  paste(base.dir,"data",sep="")
dir.cleanData <-  paste(base.dir,"output/data/",sep="")
Variables     <-  read.csv(paste(base.dir,"R/variable_definitions.csv",sep=""))

# All CSV files in cleandata directory.
csvfiles      <-  list.files(path=dir.cleanData, pattern="\\.csv", recursive=T, full.names=T)

#exclude alldata file
csvfiles      <-  csvfiles[-grep("AllData", csvfiles, fixed=T)]

# Read all data.
alldata       <-  lapply(csvfiles, read.csv)

# Total list of variables allowed in the database:
AllowedVars   <-  as.character(Variables[,1])
AllowedVars   <-  c(AllowedVars, as.character(paste(AllowedVars[c(4:48,52,58)], rep(paste(".", 1:5, sep=""), each=length(AllowedVars[c(4:48,52,58)])), sep="")), as.character(paste("method_", AllowedVars[c(4:48,52,58)], sep="")), as.character(paste("method_", AllowedVars[c(4:48,52,58)], rep(paste(".", 1:5, sep=""), each=length(AllowedVars[c(4:48,52,58)])), sep="")))

# Check if all names in allowedvars. Print which ones are wrong.
for(i in 1:length(alldata)){  
  notstandard<-which(!(lownames(alldata[[i]]) %in% tolower(AllowedVars)))
  if(length(notstandard)>0){
    cat("\nNon-standard names excluded from file",csvfiles[i],": ")
    cat(names(alldata[[i]])[notstandard], sep= " ")
    
    #remove non standard data
    alldata[[i]]<-alldata[[i]][,-notstandard]
    }
}

# Assuming things are fixed, or variables not matching will be ignored (individual files could
# have extra info we won't use, for example).
allnames <- unique(unlist(lapply(alldata,lownames)))

# Sort in order of 'AllowedVars', standardize case.
allnames <- allnames[order(match(allnames,tolower(AllowedVars)))]
allnames <- AllowedVars[match(allnames,tolower(AllowedVars))]

# sort alldata in this order. Make all var names lowercase.
alldata <- lapply(alldata, function(x){
  x <- x[,order(match(lownames(x),tolower(allnames)))]
  # standardize case
  names(x) <- AllowedVars[match(tolower(names(x)),tolower(AllowedVars))] 
  return(x)
})

# smart Rbind - doesn't require exact match between columns of the two datasets. takes variable list from the first dataframe
Rbind <- function (dfr1, dfr2) 
{
  merger <- vector("list", ncol(dfr1))
  names(merger) <- names(dfr1)
  for (i in 1:length(merger)) {
    nam <- names(merger)[i]
    # browser()
    if (!(tolower(nam) %in% lownames(dfr2))) 
      merger[[i]] <- rep(NA, nrow(dfr2))
    else merger[[i]] <- dfr2[, nam]
  }
  dfr <- rbind(dfr1, as.data.frame(merger))
  return(dfr)
}

# Create one big dataframe.

#start with empty dataframe with all variables included
emptydfr <- matrix(ncol=length(allnames),nrow=1)
colnames(emptydfr) <- allnames
emptydfr <- as.data.frame(emptydfr)

#bind all datasets together
AllData <- emptydfr
for(i in 1:length(alldata)){
  AllData <- Rbind(AllData, alldata[[i]])
}
AllData <- AllData[-1,]

# EXPORT to file
#filen <- paste(dir.cleanData,"/AllData.csv",sep="")
#write.csv(paste(dir.cleanData,"/AllData ",format(Sys.time(),"%Y-%m-%d"),".csv",sep=""), filen, row.names=FALSE, na=" ")
write.csv(AllData,paste(dir.cleanData,"/AllData.csv",sep=""), row.names=FALSE, na=" ")

#cleanup
rm(emptydfr, AllowedVars, csvfiles, allnames, alldata, notstandard)