source("email-fun.R")
extractStudy <- function(alldata, study) {
    for (var in c("data", "contacts", "references"))
        alldata[[var]] <- alldata[[var]][alldata[[var]]$studyName ==study, ]

    alldata[["bib"]] <- alldata[["bib"]][[study]]

    alldata
}

sendEmail<- function(alldata, study){
  dat    <-  extractStudy(alldata, study)

  email.text  =  paste0("Dear ", paste0(dat$contacts$name, collapse = ", "),",

We previously contacted you regarding a biomass and allometry database we are developing, which we plan to submit as a 'data paper' to the journal 'Ecology'.

You kindly contributed data from the publication: ", dat$references$citation[1],"

We are delighted to be (finally) sharing a draft of the paper with you for comment. Without a doubt, this compilation has also emerged as an extraordinary resource of which we can all be rightly very proud.

To assist us in communicating with 85 co-authors, we are asking that you return your comments on the paper by filling out this form within the next 2 weeks: http://bit.ly/BAAD-feedback
Please list your repsonses for this study under the name: ", study,".

We look forwards to hearing from you shortly. If you cannot reply within 2 weeks please indicate when you will be able to respond.

With best regards,
Daniel Falster and Remko Duursma

PS. Please find the following files attached to this email:

* ", "ms.html: draft paper for submission to Ecology. (Download first before opening)
* ", paste0(study, ".html"), ": the final report generated from the data you provided. This will be included as an attachment with the datapaper. (Download first before opening)
* studyContact.csv: your contact details
* studyMetadata.csv: includes details about the methods used in your study
* dataMatchColumns.csv: includes details about the variables used in your study
* ", paste0(study, ".csv"), ": a subset of the entire dataset correpsodning to your study
* methodsDefinitions.csv: codes for methods used in the study\n\n\n")

attachments <- c(
  "ms/ms.html",
  file.path("output/reports", paste0(study, ".html")),
  file.path("data", study, "studyContact.csv"),
  file.path("data", study, "studyMetadata.csv"),
  file.path("data", study, "dataMatchColumns.csv"),
  file.path("output/cache", paste0(study, ".csv")),
  "config/methodsDefinitions.csv")

email(content =   email.text,
        subject = "Biomass and allometry database: draft paper for your comment",
        to =  dat$contacts$email,
        from="daniel.falster@mq.edu.au",
        bcc= character(0),
        cc= c("remkoduursma@gmail.com"),
        files = attachments,
        send=FALSE
  )
}

baad <- readRDS("output/baad.rds")

# Exclude studies by "Masae Ishihara", except those when Hagihara is involved
exclude <- setdiff(unique(baad$contacts$studyName[baad$contacts$name == "Masae Ishihara"]), unique(baad$contacts$studyName[baad$contacts$name == "Akio Hagihara"]))

for (d in setdiff(unique(baad$contacts$studyName), exclude))
  sendEmail(baad, d)


# compile attachments for Ishihara's team

for (d in exclude)
  file.copy(file.path("output/reports", paste0(d, ".html")), file.path("output/Ishihara", paste0(d, ".html")))
