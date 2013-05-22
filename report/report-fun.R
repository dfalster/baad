library(knitr, quietly=TRUE)

dir.Emails    <-  "output/email"
source('R/import.R')
source('R/email.R')
source('R/plotting.R')
source('R/formatBib.R')



#creates html reports using knitr
emailReport <- function(alldata, study,
                        contentFile ="report/report-1-email.R",
                        reprocess=FALSE,
                        send=FALSE){
  
  source(contentFile)  #defines function getEmailDetails
  details <- getEmailDetails(alldata, study, reprocess=reprocess)
  
  email(content = details$content,
        subject = details$subject, 
        to = details$to, from =details$from, bcc=details$bcc, cc=details$cc, 
        files= details$filesToSend, 
        send=send)
}  
  

printAllStudyReports <- function(data, studynames= getStudyNames(), reprocess=FALSE, progressbar=TRUE){
  
  message("Generating ", length(studynames), " markdown reports.")
  if(progressbar){
    wp <- txtProgressBar(min = 0, max = length(studynames), 
                         initial = 0, width = 50, style=3)
  }
  
  output<-list()
  for(i in seq_along(studynames)){
    output[[i]]<-printStudyReport(data, studynames[i], reprocess=reprocess)
    if(progressbar)setTxtProgressBar(wp, i)
  }
  
  if(progressbar)close(wp) 
output
}


#creates html reports using knitr
printStudyReport <- function(alldata, study=NULL, RmdFile ="report/report-1.Rmd", path="output/report-by-study", name=NULL, delete=TRUE, reprocess=FALSE){
  
  #if no name provided, use study name
  if(is.null(name)) 
    name <- study
  #if study is null
  if(is.null(name)) 
    name <- "all"
  
  knitThis(RmdFile = RmdFile, path=path, name=name, delete=TRUE, reprocess=reprocess, 
           predefined=list(.study = study, alldata=alldata, .dat = extractStudy(alldata, study))) 
}


#creates html reports using knitr, copies output file to desired location and renames as required
knitThis <- function(RmdFile ="report/reportmd.Rmd", path="output/report-per-study", 
                     name="study", delete=TRUE,
                     reprocess=TRUE, ..., predefined=list(...)){
  
  outputfile<- paste0(path,"/",name,".html")
  
  if ( reprocess || !file.exists( outputfile) ){
    
    #create new environment with predfined variables
    e <- new.env()
    if (length(predefined) > 0) { 
      #avoid issues when variables unnamed
      if (is.null(names(predefined)) || any(names(predefined) == ""))
        stop("All extra variables must be named")
      
      for ( v in names(predefined))
        assign(v, predefined[[v]], e)
    }
    
    #knit
    suppressMessages(knit2html(RmdFile, quiet=TRUE, envir=e))
    
    #copy html file to output dir
    if(!file.exists(path)) 
      dir.create(path, recursive=TRUE)
    
    #extract filename from RmdFile 
    filebits <- strsplit(RmdFile, "/")[[1]]
    filename <- filebits[length(filebits)]
    
    #copy html file to output dir, rename
    file.copy(sub("Rmd", "html", filename), outputfile, overwrite =  TRUE)
    
    #delete support files
    if(delete){
      unlink(sub("Rmd", "html", filename))
      unlink(sub("Rmd", "md", filename))
      unlink("figure", recursive=TRUE) 
    }
  }  
  outputfile
}


locLevelInfo  <-  function(data){
  
  vars <- c("location","map","mat","longitude","latitude","vegetation")
  
  loc <- data[!duplicated(data[,vars]),vars]
  
  loc[is.na(loc) | loc=="" | loc=="NA"]  <-  "????"  
  return(loc)
}


standLevelInfo  <-  function(data){
  
  vars <- c("location","grouping","growingCondition","status")
  sta <- data[!duplicated(data[,vars]),vars]
  
  
  if(all(is.na(sta$grouping)))
    sta  <-  sta[,c("location", "growing_condition", "status")]
  
  sta[is.na(sta) | sta=="" | sta=="NA"]  <-  "????"  
  
  return(sta)
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

generateDataNew  <-  function(data, studyName, levels=c("site","species","tree")){
  
  # Extract dataframe of observations only
  data <- data$data
  dat  <- data[data$dataset == studyName, ]
  
  checked  <-  lapply(levels, function(x){checkLevels(dat, x)})
  dataNew  <-  data.frame(stringsAsFactors=FALSE)
  for(z in 1:length(checked)){
    dataNew  <-  rbind(dataNew,checked[[z]])
  }

  if(!file.exists(dir.Emails))
    dir.create(dir.Emails)
  
  tdir  <-  paste0(dir.Emails, "/", studyName)
  if(!file.exists(tdir)){
    dir.create(tdir)
  }
  write.csv(dataNew, paste0(dir.Emails, "/", studyName, "/dataNew.csv"))
  
}


checkLevels  <-  function(site.data, group){
  #get essential variables for the chosen group
  chosen  <-  var.def$Variable[var.def$Group==group & var.def$essential==TRUE]
  #find NA's
  nas     <-  apply(site.data[names(site.data) %in% chosen], 2, function(x){which(is.na(x))})
  if(class(nas) == "matrix"){
    nas  <-  as.data.frame(nas)
  }
  if(length(nas)>0){
    #create empty dataframe for dataNew results
    dataNew  <-  data.frame()
    for(k in 1:length(nas)){
      if(length(nas[[k]]) > 0){
        if(length(nas[[k]])==length(site.data[[names(nas[k])]])){
          dataNew  <-  rbind(dataNew,data.frame(a="",b="",c=names(nas[k]),d="",e="",stringsAsFactors=FALSE))
        } else {
          for(i in nas[[k]]){
            bit      <-  site.data[i,chosen[-k]]
            dataNew  <-  rbind(dataNew,data.frame(a=chosen[-k][which(!is.na(bit))[1]],b=bit[!is.na(bit)][1],c=names(nas[k]),d="",e="",stringsAsFactors=FALSE))
          }
        }
      }
    }
    names(dataNew)  <-  c("lookupVariable","lookupValue","newVariable","newValue","source")
  }
  if(length(nas)>0){return(dataNew)}
}

