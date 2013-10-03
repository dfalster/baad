rm(list=ls())

source('R/email.R')

sendInvitation <- function(dat){
  cols <- names(dat)[10:57]
  vars <- dat=='x' & names(dat) %in% cols
  collected <- paste(names(dat)[vars], collapse = ", ")

  email.text  =  paste0("Dear ", dat[["Contact"]],",

We are writing to invite you to co-author a 'Data paper' in the journal Ecology, gathering together size and biomass data for woody plants from across the globe. Literally tens of thousands of plants have been measured or harvested in different experiments and studies; gathered together such data would have enormous value and represent an important resource for the community.

We are contacting you because we read your ", dat[["Year"]]," paper '", dat[["Title"]],"' in the journal '", dat[["Journal"]],"', in which you measured ", collected, " for ", dat[["Individuals"]]," individuals from ", dat[["Species"]]," species. This data seems highly suitable for inclusion in this project.

We have already collated data from almost 100 studies, covering over 400 species and 10,000 individuals. We are contacting you as part of our last round of recruitment for the study, having identified your study as making a quality contribution to the database, in addition to the datasets already included.

Why should I participate?
  * We are planning to submit a 'Data paper' to the journal Ecology. The dataset will be open access and we expect the paper to be widely cited. All data contributors will be included as co-authors, so for little additional effort you could add a well-cited Ecology paper to your CV.
  * By participating you ensure your data remains available (via the ESA archives) into the future, thereby increasing the impact of your work.
  * Once the dataset has been compiled, we will send you a report showing how your data compares to other studies. This will give additional insight into your study system.

Who will use the data?
  * The dataset will be open-access. Once published, anyone can pursue and publish his or her own analyses, including you.
  * Beyond regular papers, we expect many groups developing vegetation models will use the data set to parameterise and test parts of their model.

Should I worry about sending you my data?
  * No. We have intentionally chosen a publication model that recognises the hard work of data collectors.  By making you a co-author on the data paper, we ensure you receive proper credit (via citation) anytime the data is used. By making the dataset open to the public, we hope to prevent anyone from thinking we have ownership of your data.
  * Unless you indicate otherwise, your name will be listed in the metadata as the relevant contact for the data you provide.

I'm in! What is the process from here?
  * We are in the final phases of compiling the dataset and require a rapid response if you are to particpate.
  * We ask that you first simply send us an 'Expression Of Interest', listing the variables you are able provide. See this website for more information on the project, a draft abstract, and a list of the essential and desired variables: http://bio.mq.edu.au/research/groups/ecology/allometry/
  * Once your participation has been confirmed, we will request a spreadsheet with the data. Jeff Kelly (CC) will handle the inital processing of your data.

We look forward to hearing from you.

Yours sincerely,

Dr Daniel Falster - ARC Postdoctoral Research Fellow, Macquarie University, Australia
Dr Remko Duursma - Research Lecturer, The University of Western Sydney, Australia
Dr Jeff Kelly - Research Assistant, The University of Western Sydney, Australia\n")

  email(content =   email.text,
        subject = "A biomass and allometry database - Invitation to participate",
        to =  dat[["Email"]],
        from="daniel.falster@mq.edu.au",
        bcc= character(0),
        cc= c("remkoduursma@gmail.com", "jeffkelly9@gmail.com"),
        files = character(0),
        send=FALSE
  )
}

all_data <- read.csv("config//ToContact.csv", stringsAsFactors = FALSE, check.names=FALSE )

for(i in 1:length(all_data[,1]))
  sendInvitation(all_data[i,])
