library(knitr, quietly=TRUE)

if("multicore" %in% .packages(TRUE))
  library(multicore, quietly=TRUE)


dir.Emails    <-  "output/email"
source('R/import.R')
source('R/email.R')
source('R/plotting.R')
source('R/formatBib.R')



#creates html reports using knitr
emailReport <- function(alldata, study,
                        contentFile ="report/report-1-email.R",
                        reprocess=FALSE,
                        send=FALSE,
                        updateStage=TRUE,
                        print.only=FALSE){
  
  source(contentFile)  #defines function getEmailDetails
  details <- getEmailDetails(alldata, study, updateStage=updateStage, reprocess=reprocess, print.only=print.only)
  
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




