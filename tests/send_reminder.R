rm(list=ls())

source('report/report-fun.R')
source('report/report-1-email.R')

# Load all data
dat <- loadStudies(reprocess=TRUE)

sendReminder<- function(alldata, study){
  dat    <-  extractStudy(alldata, study)
  email(content = paste0("Dear ", dat$contact$name, ",", "\n\nWe have recently contacted you to let you know that our database project is progressing really well despite the unforeseen delays and we also sent you an initial report with questions to be answered for inspection. This has been one month already and we did not hear back from you yet. Since great part of the remaining authors have already replied and their studies are ready to be incorporated in the final datapaper, we were wondering if you could reply to our request soon?","\n\nBest regards","\nDaniel Falster, Remko Duursma, Diego Barneche"),
        subject = paste0("Reminder for revision allometry database ", study),
        to =  dat$contact$email, 
        from="daniel.falster@mq.edu.au",  
        bcc= character(0), 
        cc= c("remkoduursma@gmail.com", "barnechedr@gmail.com", "daniel.falster@mq.edu.au"), 
        files = character(0),
        send=FALSE
        )
}  
  
#test single
sendReminder(alldata=dat, "Baltzer2007")

#all
reminders  <-  c("Baltzer2007", "Baraloto2006", "Coll2008", "Domec2012", "Garber2005", "Gargaglione2010", "Ishihara0000", "Kelly0000a", "Kelly0000b", "Lewis2013", "Maguire1998", "Monserud1999", "Mori1991", "Myster2009", "O'Grady2000", "O'Grady2006", "Osunkoya2007", "Peri0000", "Peri2008", "Peri2011", "Reid2004", "Roeh1997", "Roth2007", "SantaRegina0000", "SantaRegina1999", "Sillett2010", "Tissue0000c", "Wang1995", "Wang1996", "Wang2000", "Wang2011")
sapply(reminders, sendReminder, alldata=dat)

