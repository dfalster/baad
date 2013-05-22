
getEmailDetails <- function(alldata, study, reprocess= FALSE){
  
  dat<-extractStudy(alldata, study)
  
  reportPath=printStudyReport(alldata, study, reprocess=reprocess) 
  
  list(subject = generateEmailSubject(study),
       to =  dat$contact$email, 
       from="daniel.falster@mq.edu.au",  
       cc= c("remkoduursma@gmail.com", "barnechedr@gmail.com"), 
       bcc= character(0), 
       content = generateEmailContent(alldata, study, dat),
       filesToSend = c(reportPath, 
                       makeQuestionsFile(study),
                       dat$contact$filename,
                       dat$ref$filename, 
                       file.path(data.path(study, "studyMetadata.csv")),
                       generateDataNew(alldata, study),
                       file.path(data.path(study, "data.csv")),
                       paste0("output/data/", study, ".csv"),
                       "config/variableDefinitions.csv"
                       )
  )
}


generateEmailSubject <-function(study){
  paste0("Biomass and allometry database: report on ", study) 
}

generateEmailContent <-function(allData, study, studyData){
     
  paste0("Dear ", paste0(studyData$contact$name, collapse = " and "),",

Last year you kindly agreed to contribute data to a biomass and allometry database for woody plants, for publication as a data paper in the journal Ecology. 

We had a fantastic response to our request for data, with data now collected from ", length(unique(allData$ref$dataset)), " studies, with information for ", length(allData$data$dataset), " individuals from ", length(unique(allData$data$location)), " locations, covering ",length(unique(allData$data$species)), " species. We are certain this dataset will be a widely used resource.

The purpose of this email is to provide you with a report on the data you contributed for you to review, before we submit our paper. The database is organised by publication, so if you contributed data from more than one publication, you will receive multiple emails. 

This email contains a report for the study: ",
        formatBib(studyData$ref$filename)[[1]],
         ".\n
To assist us in preparing the data for publication, we request that you review the attached report and provide answers to ALL of the questions listed in the file 'report1-questions.txt' attached. We require all questions be answered for a study to be included in the final dataset. 

The following files are attached to this email: 
\t ", paste0(study, ".html"), ": is a report generated from the data you provided
\t report1-questions.txt: is the list of questions we would like you to answer
\t studyContact.csv: includes the contact nfomration we have for you
\t studyRef.bib: includes citation details for your study 
\t studyMetadata.csv: includes details about the methods used in your study
\t data.csv: is the original data file you provided
\t ", paste0(study, ".csv"), ": is a cleaned data file, with units used in our data paper
\t variableDefinitions.csv: provides names, units and definitions used in our data paper.

By returing the requested information you are assisting us in handling a large number of files and corrections.

We look forward to hearing from you. If you could reply within the next 2 weeks that would be much appreciated. If you are unable to reply within this time period, please send us a quick reply to let us know when we can expect to hear from you. 

With best regards,
Daniel Falster, Remko Duursma, Diego Barneche \n\n"       
         )
}

makeQuestionsFile <- function(study, outputDir="output/questions"){
  

  filename<- file.path(outputDir, study,"report1-questions.txt")
  
  if(!file.exists(dirname(filename)))
    dir.create(dirname(filename), recursive=TRUE)  
  
  con <- file(filename, "w")  
  cat("Questions about the study: ", study, "

1. Is your contact information correct?
\tIf not, could you please revise the information in the attached studyContact.csv file and send it to us?

2. Is your reference information correct?
\tIf not, could you please revise the information in the attached studyContact.csv file and send it to us?

3. Does the number of records for each variable seem reasonable based on the datafile you provided?

4. Is 'Location data' complete?
\t If not, could you please provide the missing information in the attached file dataNew.csv. The codes and legends for Vegetation_type are provided in the file Variable.definition.csv, also attached.
  
5. Do your locations fall in the right spot in both world and country map?
  
6. Is the 'Stand description' complete?
\t If not, could you please fill in the missing information in dataNew.csv? Codes and legends for Growing_condition and Status are found within Variable.definition.csv file attached.  
  
7. Is the 'Species data' correct? What about plant functional type (pft)?  
\t If not, please correct the data in dataNew.csv and check the relevant codes for pft in Variable.definition.csv.
  
8. Is the 'Methods' information complete and accurate? 
\t If not, could you please provide the missing infomration in Metadata.csv file attached? These Metadata should be a short description (up to 4 lines) of each of the items listed. Additional items not listed in the report are not needed, but if you judge it really important add it to 'Other variables'.
  
9. Please review the plots showing how your data compares to other data in the study. Does your data fall well within the rest of the dataset?  Are there outliers? 
\t If so, could you please review the original data file you provided us with and verify that all iformation is correct.", 
      file = con, sep = " ")

  #Add details in extra questions file
  extraQuestionsFile <- file.path(data.path(study), "questions.txt")
   if(file.exists(extraQuestionsFile)){
     extraQuestions <-  readLines( extraQuestionsFile)
     
     extraQuestions <-  extraQuestions[extraQuestions!=""]
     
     N <- 9 + seq_len(length(extraQuestions))
     cat(paste0("\n\n", N, ". ", extraQuestions, collapse ="\n"),  file = con, sep = "")
   }
  
  close(con)
  filename  
}


generateDataNew  <-  function(alldata, studyName, levels=c("site","species","tree"), output.dir="output/questions"){
  
  filename <- paste0(output.dir, "/", studyName, "/dataNew.csv")

  # Extract dataframe of observations only
  dat<-extractStudy(alldata, studyName)$data
  
  checked  <-  lapply(levels, function(x){checkLevels(dat, x)})
  dataNew  <-  data.frame(stringsAsFactors=FALSE)
  for(z in 1:length(checked)){
    dataNew  <-  rbind(dataNew,checked[[z]])
  }
  
  if(!file.exists(dirname(filename)))
    dir.create(dirname(filename), recursive=TRUE)  
  
  write.csv(dataNew, filename, row.names=FALSE)
  
  filename
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

