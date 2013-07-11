sendReminder<- function(alldata, study){
  dat    <-  extractStudy(alldata, study)
  
  email.text  =  paste0("Dear ", paste0(dat$contact$name, collapse = " and "),",

We recently contacted you regarding the biomass and allometry database we are developing, and for which we plan to submit a data paper to Ecology.

You kindly contributed data from the publication: ", formatBib(dat$ref$filename)[[1]],".

On Jun 7th we sent a report on your contribution, with some questions to be answered. As it is now one month since we sent that email, we are sending you a gentle reminder to please have a look at the report and send us your response as asson as possible.

We have now heard back from most of the data contributors and eagerly await your response.  

With best regards,
Daniel Falster, Remko Duursma, Diego Barneche\n")
  
email(content =   email.text,
        subject = paste("RE:",generateEmailSubject(study)),
        to =  dat$contact$email, 
        from="daniel.falster@mq.edu.au",  
        bcc= character(0), 
        cc= c("remkoduursma@gmail.com", "barnechedr@gmail.com", "daniel.falster@mq.edu.au"), 
        files = character(0),
        send=FALSE
  )
}  


getEmailDetails <- function(alldata, study, updateStage=TRUE, reprocess=FALSE, print.only=FALSE){
  
  dat                =  extractStudy(alldata, study)
  reportPath         =  printStudyReport(alldata, study, reprocess=reprocess) 
  email.content      =  generateEmailContent(alldata, study, dat, updateStage=updateStage, print.only=print.only)
  email.text         =  email.content$text
  study.init.stage   =  email.content$initial.stage
  study.final.stage  =  email.content$final.stage
    
  if(study.init.stage == 1 & study.final.stage == 2){
  attachments  =  c(reportPath, 
                    makeQuestionsFile(study),
                    file.path(data.path(study, "studyMetadata.csv")),
                    file.path(data.path(study, "data.csv")),
                    paste0("output/data/", study, ".csv"),
                    "config/variableDefinitions.csv"
                   )
  }
  
  if(study.init.stage == study.final.stage & study.final.stage==2)
    attachments  =  file.path(data.path(study, "review/new_questions.txt"))
  
  if(study.final.stage == 3)
    attachments  =  reportPath
  
  list(subject = generateEmailSubject(study),
       to =  dat$contact$email, 
       from="daniel.falster@mq.edu.au",  
       cc= c("remkoduursma@gmail.com", "barnechedr@gmail.com", "daniel.falster@mq.edu.au"), 
       bcc= character(0), 
       content = email.text,
       filesToSend = attachments
  )
}


generateEmailSubject <-function(study){
  paste0("Biomass and allometry database: report on ", study) 
}

generateEmailContent <-function(allData, study, studyData, updateStage, print.only=FALSE){
  
  stage <- getStage(study)
  
  em <- NA
  if(stage==1){
    em <- paste0("Dear ", paste0(studyData$contact$name, collapse = " and "),",

Last year you kindly agreed to contribute data to a biomass and allometry database for woody plants, for publication as a data paper in the journal Ecology.  Overall we had a fantastic response to our request for data, with data now collected from ", length(unique(allData$ref$dataset)), " studies, with information for ", length(allData$data$dataset), " individuals from ", length(unique(allData$data$location)), " locations, covering ",length(unique(allData$data$species)), " species. We are certain this dataset will be a widely used resource and thank you for your contribution.

The purpose of this email is to provide you with a report on the data you contributed to the study. The database is organised by publication, so if you contributed data from more than one publication, you will receive multiple emails. We kindly request that you review each of these before we submit our paper for publication, to ensure all the information is correct. Unless there are major issues with your data, it should only take a few minutes to complete each review.

This email contains a report for the following study, for which you are listed as contact person: ", formatBib(studyData$ref$filename)[[1]],".

Please note, to view the report you should first download it, then open in your web browser. If you open it directly from a web-based email program the plots may not display.

To assist us in preparing the data for publication, we ask that you review the attached report of your data and provide answers to ALL of the questions listed in the file 'report1-questions.txt' attached. We require all questions be answered for a study to be included in the final dataset. Please type your answers directly into the attached files, as instructed.  By returning the requested information in this way, you are assisting us in handling a large number of files and corrections. Also, if you have modifications to make in your data, please do so in the original data.csv file and return it to us together with your reply, as we prefer to keep track of changes from the original file and not its final product.

We look forward to hearing from you. If you could reply within the next 2 weeks that would be much appreciated. If you are unable to reply within this time period, please send us a quick reply to let us know when we can expect to hear from you. 

With best regards,
Daniel Falster, Remko Duursma, Diego Barneche\n

Please find the following files attached to this email: 
\t ", paste0(study, ".html"), ": is a report generated from the data you provided. Download to open.
\t report1-questions.txt: is the list of questions we would like you to answer
\t studyMetadata.csv: includes details about the methods used in your study
\t data.csv: is the original data file you provided
\t ", paste0(study, ".csv"), ": is a cleaned data file, with units used in our data paper
\t variableDefinitions.csv: provides names, units and definitions used in our data paper. \n\n\n"
    )
    print(paste0("argument updateStage ignored for ", study, " as this study will be automatically updated to stage 2"))
    new.stage  <-  updateStage(study, stage+1, print.only=print.only)
  }
  
  if(stage==2){
    if(updateStage == FALSE){
      em <- paste0("Dear ", paste0(studyData$contact$name, collapse = " and "),",

You recently replied to our email requesting more information about the data you contributed to the Biomass and Allometry database we are assembling. Thank you for taking the time to respond to our email - that was most helpful. 

After carefully reviewing the additional information you provided, we identified some minor outstanding issues that still require attention, before we can finalise your contribution to our datapaper. Could you please reply to the questions found below within the attached file entitled 'new_questions.txt'.

We look forward to hearing from you. We would really appreciate if you could reply within the next week. If you are unable to reply within this time period, please send us a quick reply to let us know when we can expect to hear from you.

With best regards,
Daniel Falster, Remko Duursma, Diego Barneche \n\n\n"
      )
      new.stage  <-  updateStage(study, stage, print.only=print.only)  
      
    } else {
      em <- paste0("Dear ", paste0(studyData$contact$name, collapse = " and "),",

You recently replied to our email requesting more information about the data you contributed to the Biomass and Allometry database we are assembling. Thank you for taking the time to respond to our email - that was most helpful.
   
We are pleased to tell you that we now have all the information needed to include your study in our datapaper. We would like to take the opportunity and thank you for your collaboration. As soon as we have the other studies properly incorporated, we will contact you back for a first draft of the paper.
              
With best regards,
Daniel Falster, Remko Duursma, Diego Barneche\n
   
Please find the following file attached to this email: 
\t", paste0(study, ".html"), ": is the final report for your appreciation. Download to open. \n\n\n"
      )
      new.stage  <-  updateStage(study, stage+1, print.only=print.only)  
    }
  }
  
  if(print.only==FALSE)
    final.stage <- getStage(study)
  else
    final.stage <- new.stage$progress[new.stage$study==study]
  
  list(text=em, initial.stage=stage, final.stage=final.stage)
  
}


getStage  <-  function(study){
  prog  <-  read.csv("config/progress.csv", h=TRUE, stringsAsFactors=FALSE)
  prog$progress[prog$study==study]
}

updateStage  <-  function(study, newStage, print.only=FALSE){
  prog                              <-  read.csv("config/progress.csv", h=TRUE, stringsAsFactors=FALSE)
  
  if(prog$progress[prog$study==study] != newStage){
    prog$progress[prog$study==study]  <-  newStage
  }
  
  email.date                        <-  getCurrentDate()
  prog$comment[prog$study==study]   <-  paste0("emailed ", email.date)
  
  if(print.only==FALSE)
    write.csv(prog, "config/progress.csv", row.names=FALSE, quote=FALSE)
  else
    print(prog[prog$study==study, ])
  prog
}

getCurrentDate  <-  function(){
  email.date  <-  as.character(Sys.time())
  reg         <-  "([0-9.]+)[[:space:]].*"
  email.date  <-  unname(sub(reg, "\\1", email.date))
  return(gsub("-", ".", email.date))
}

makeQuestionsFile <- function(study, outputDir="output/questions"){
  

  filename<- file.path(outputDir, study,"report1-questions.txt")
  
  if(!file.exists(dirname(filename)))
    dir.create(dirname(filename), recursive=TRUE)  
  
  #list of questions
  questions <- c(
    "Is your contact information correct?
\tIf not, could you please provide correct information.",

"Is your reference information correct?
\tIf not, could you please provide correct information.",

"Does the number of records for each variable seem reasonable based on the datafile you provided?
\t For your interest, the raw data file you originally sent us and the cleaned data file are both attached.",

"Is 'Location data' complete?
\t If not, could you please provide any items marked 'missing' here. The codes and legends for Vegetation_type are provided in the file Variable.definition.csv, also attached.",

"Do your locations fall in the right spot in both world and country map?
\t If not, please outline the issues here and provide us with updated longitude and latitude data.",

"Is the 'Stand description' complete?
\t If not, could you please provide more information? Codes and legends for Growing_condition and Status are found within Variable.definition.csv file attached.",

"Is the 'Species data' correct, i.e. name, family, plant functional type (pft)?  
\t If not, please provide details where possible.",

"Is the 'Methods' information complete and accurate? 
\t If not, could you please provide the missing information in Metadata.csv file attached? These Metadata should be a short description (up to 4 lines) of the methods used for each of the items listed. Additional items not listed in the report are not needed, but if you judge it important, add it to 'Other variables'.",

"Please review the plots showing how your data compares to other data in the study. Does your data fall well within the rest of the dataset?  Are there outliers? 
\t If so, could you please review the original data file you provided us with and verify that all information is correct.",

"The data archived with the publication will be archived under the  Creative Commons Zero (CC0) licence (http://creativecommons.org/about/cc0). This is the same license used by a number of data repositories, such as datadryad (http://datadryad.org/pages/policies).
\t Please indicate that you understand what this means and agree to this by answering 'yes' or 'I agree' here")

  #Add details in extra questions file
  extraQuestionsFile <- file.path(data.path(study), "questions.txt")
   if(file.exists(extraQuestionsFile)){
     extraQuestions <-  readLines( extraQuestionsFile)
     questions<- c(questions, extraQuestions[extraQuestions!=""])     
     }

  con <- file(filename, "w")  

  #PRINT TO FILE
  cat("Questions about the study: ", study, "

Please look at the attached html report ", paste0(study, ".html"), " and answer the following questions. Type your answers directly into this file, or into the other files as indicated.\n\n", 
      file = con, sep = " ")

 cat(paste0(seq_len(length(questions)), ". ", questions, "\nANSWER: \n", collapse ="\n"),  file = con, sep = "")
  
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
  chosen  <-  mashrDetail("var.def")$Variable[mashrDetail("var.def")$Group==group & mashrDetail("var.def")$essential==TRUE]
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

