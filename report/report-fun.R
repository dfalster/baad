library(knitr, quietly=TRUE)

dir.Emails    <-  "output/email"


allStudyReport <- function(data, studynames= getStudyNames(), progressbar=TRUE){
  
  message("Generating ", length(studynames), " markdown reports.")
  if(progressbar){
    wp <- txtProgressBar(min = 0, max = length(studynames), 
                         initial = 0, width = 50, style=3)
  }
  
  for(i in seq_along(studynames)){
    studyReportMd(data, studynames[i])
    if(progressbar)setTxtProgressBar(wp, i)
  }
  
  if(progressbar)close(wp)
  
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


#creates html reports using knitr
studyReportMd <- function(alldata, study=NULL, Dir="report-per-study", delete=TRUE){
  
  .study <- study
  .dat <- extractStudy(alldata, study)
  
  #Check output directory exists
  path<-paste0("output/", Dir)
  if(!file.exists(path)) dir.create(path, recursive=TRUE)
  
  suppressMessages(knit2html("report/reportmd.Rmd", quiet=TRUE))
  
  file.copy("reportmd.html", paste0(path,"/",.study,"-report.html"))
  
  #delete support files
  if(delete){
    unlink("reportmd.md")
    unlink("reportmd.html")
    unlink("figure", recursive=TRUE) 
  }
  
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


emailFiles  <-  function(data, studyName){
  contact    <-  read.csv(paste0(dir.rawData,"/",studyName,"/studyContact.csv"), h=TRUE,stringsAsFactors=FALSE)
  reference  <-  read.csv(paste0(dir.rawData,"/",studyName,"/studyRef.bib"), h=TRUE,stringsAsFactors=FALSE)
  write.csv(contact, paste0(dir.Emails,"/",studyName,"/studyContact.csv"))
  write.csv(reference, paste0(dir.Emails,"/",studyName,"/studyRef.bib"))
  write.csv(var.def, paste0(dir.Emails,"/",studyName,"/Variable_definitions.csv"))
}
