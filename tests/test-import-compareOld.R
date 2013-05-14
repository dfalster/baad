
library(testthat)
rm(list=ls())
source('R/import.R')
source("test/test-import-fun.R")

#Remove existing data files
unlink("output/data/*")

#names of all studies
#studyNames     <-  getStudyNames()

studyNames     <- c("Aiba2005", "Aiba2007", "Baltzer2007", "Baraloto2006", "Bond-Lamberty2002", "Coll2008", "Delagrange2004", "Domec2012", "Epron2012", "Harja2012", "Kenzo2009", "Kenzo2009b", "Kohyama1987", "Kohyama1990", "Kohyama1994", "leMaire2011", "Lusk0000a", "Lusk0000b", "Lusk2002", "Lusk2004", "Lusk2011", "Lusk2012", "Martin1998", "McCulloh2010", "Mokany2003", "Mori1991", "Myster2009", "Nouvellon2010", "O'Grady2000", "O'Grady2006", "O'Hara0000", "O'Hara1995", "Osada0000", "Osada2003", "Osada2005", "Osunkoya2007", "Petritan2009", "Ribeiro2011", "Rodriguez2003", "Roeh1997", "Salazar2010", "SantaRegina1999", "Selaya2007", "Selaya2008", "Selaya2008b", "Sillett2010", "Stancioiu2005", "Sterck0000", "Sterck2001", "Valladares2000", "Wang1995", "Wang1996", "Wang2000", "Wang2011", "Yamada1996", "Yamada2000")


#import data
data<-lapply(studyNames[-c(4,35,36,39,54)], importAndCheck, verbose=TRUE)

#Test single study
d<-importAndCheck("Aiba2005", verbose=TRUE)


