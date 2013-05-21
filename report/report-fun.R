library(knitr, quietly=TRUE)

dir.Emails    <-  "output/email"



#creates html reports using knitr
emailReport <- function(studyName, reportPath= NULL, to = c("daniel.falster@mq.edu.au"), from ="daniel.falster@mq.edu.au", cc= "daniel@falsters.net"){
  
  files<-c(reportPath, 
              "config/variableDefinitions.csv", 
              paste0(dir.rawData,"/",studyName,"/studyRef.bib"),
              paste0(dir.rawData,"/",studyName,"/studyContact.csv")
              )
  content <- "Hi, iam writing"

  email(content, "About your data",
          to,
          bcc=c("fitzjohn@zoology.ubc.ca", "dfalster@bio.mq.edu.au"),
          files= files, send=FALSE)
  
#   emailFiles  <-  function(data, studyName){
#     contact    <-  read.csv(paste0(dir.rawData,"/",studyName,"/studyContact.csv"), h=TRUE,stringsAsFactors=FALSE)
#     reference  <-  read.csv(paste0(dir.rawData,"/",studyName,"/studyRef.bib"), h=TRUE,stringsAsFactors=FALSE)
#     write.csv(contact, paste0(dir.Emails,"/",studyName,"/studyContact.csv"))
#     write.csv(reference, paste0(dir.Emails,"/",studyName,"/studyRef.bib"))
#     write.csv(var.def, paste0(dir.Emails,"/",studyName,"/Variable_definitions.csv"))
  }
  
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
printStudyReport <- function(alldata, study=NULL, RmdFile ="report/reportmd.Rmd", path="output/report-by-study", name=NULL, delete=TRUE, reprocess=FALSE){
  
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


