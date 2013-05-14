rm(list=ls())
source('R/packages.R')
source('R/import.R')

# Load all data
dat <- loadStudies(reprocess=TRUE)
