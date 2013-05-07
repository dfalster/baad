
rm(list=ls())
source('R/Biomass-fun.R')
source('R/import-fun.R')
source('R/report-fun.R')
source('R/packages.R')

#names of all studies
studyNames <-  getStudyNames()

#import data
d<-addStudies(studyNames, reprocess = FALSE, verbose = FALSE)

#Retrieve familynames
library(taxize)
famnames<-tax_name(query = "Poa annua", get = "family")

species <- c("Poa annua", "Abies procera", "Helianthus annuus", "Coffea arabica")
famnames <- sapply(species, tax_name, get = "family", USE.NAMES = F)

#retrieve 
species <-unique(as.character(d$data$species))
ssp.info<-plantminer(species) #this seems to work better for plants
save(ssp.info, file = "R-working/taxize/ssp.info.RData")
#Resolve some names
resolve<- gnr_resolve(names = species[c(1,100, 200)], returndf = TRUE)

