
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
                       dat$contact$filename,
                       dat$ref$filename, 
                       file.path(data.path(study, "studyMetadata.csv")),
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
  
  
  extraQuestionsFile <- file.path(data.path(study), "questions.txt")
  if(file.exists(extraQuestionsFile))
    extraQuestions<-readLines( extraQuestionsFile)
  else
    extraQuestions<-""
  
  paste0("Dear ", paste0(studyData$contact$name, collapse = ", "),
         "

Last year you kindly agreed to contribute data to a biomass and allometry database for woody plants, for publication as a data paper in the journal Ecology. 

We had a fantastic repsonse, with data now collected from ", length(unique(allData$ref$dataset)), " studies, with infomration for ", length(allData$data$dataset), " individuals from ", length(unique(allData$data$location)), " locations, covering ",length(unique(allData$data$species)), " species. We are certain this dataset will be a widely used resource.

The purpose of this email is to propvide you with a report on the data you contributed for you to review, before we submit our paper. The database is organised by publication, so if you contributed data from more than one publication, you will receive multiple emails. 

This email contains a report for the study: ",
        formatBib(studyData$ref$filename)[[1]],
         ".\n
To assist us in preparing the data for publication, we request that you review the attached report and provide answers to ALL of the questions below. We require all questions be answered for a study to be included in the final dataset. 

1. Is your contact information correct?
\tIf not, could you please revise the information in the attached studyContact.csv file and send it to us?

2. Is your reference information correct?
\tIf not, could you please revise the information in the attached studyContact.csv file and send it to us?

3. Does the number of records for each variable seem reasonable based on the datafile you provided?

4. Is 'Location data' complete?
\t If not, could you please prvide the mssing infomration in the attached file dataNew.csv. The codes and legends for Vegetation_type are provided in the file Variable.definition.csv, also attached.

5. Are the coordinates/location complete? 
\t If the data are missing, could you please provide it by filling in the file dataNew.csv?

6. Do your locations fall in the right spot in both world and country map?

7. Is 'Stand description' complete?
\t If not, could you please fill in the missing information in dataNew.csv? Codes and legends for Growing_condition and Status are found within Variable.definition.csv file attached.  

8. Is your 'Species data' correct? What about plant functional type (pft)?  
\t If not, please correct the data in dataNew.csv and check the relevant codes for pft in Variable.definition.csv.

9. Are your 'Methods' accurate? Does it contain missing information?
\t If not, could you please provide the missing infomration in  Metadata.csv file attached? These Metadata should be a short description (up to 4 lines) of each of the items listed. Additional items not listed in the report are not needed, but if you judge it really important add it to 'Other variables'.

10. Please reviw the plots showing how your data compares to other data in the study. Does your data fall well within the rest of the dataset?  Are there outliers? 
\t If so, could you please review the original data file you provided us with and verify that all ifomration is correct.",
         extraQuestions,
         "

With best regards,
Daniel Falster\n\n"
         )
}
