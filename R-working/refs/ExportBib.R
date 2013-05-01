# Export bibs using [bibtex package](http://cran.r-project.org/web/packages/bibtex/bibtex.pdf)
# This script divides a large bibtex file into individual files for each reference


library(bibtex)

setwd('~/Dropbox/Documents/_research/Falster-Allometry/export bib')
#read full bibliography 
bibs <- read.bib("Exported Items.bib")

exportBib<-function(mybib){
  #remove some info - this does not work, doesn't recognise object as existing. Possibly due to search scope?
  # alternative use !.isnull(mybib$file) but this fails when item missing
  #   if(exists("mybib$file")) mybib$file <-NULL
  #   if(exists("mybib$month")) mybib$month <-NULL
  #   if(exists("mybib$keywords")) mybib$keywords <-NULL
  #   if(exists("mybib$urldate")) mybib$urldate <-NULL
  
  #print to file
  write.bib(mybib, paste0("~/Desktop/ref/",mybib$author[[1]]$family, mybib$year,".bib"))
}

exportBib(bibs[[1]])

tmp<-lapply(bibs, exportBib)


#Find missing DOIs with rmetadata
# - http://ropensci.org/blog/2013/03/15/r-metadata/

library(devtools)
#install_github('ROAuth','duncantl')
# install_github('rmetadata', 'ropensci') # uncomment to install
library(rmetadata)

for (i in 1:length(bibs)){
  cat(bibs[[i]]$doi, "\n")
  
  ref<-crossref_search(query = c(bibs[[i]]$title, bibs[[i]]$journal, bibs[[i]]$year), rows=1)
  cat(bibs[[i]]$doi, "\t", as.character(ref$doi),"\n")
}

# get record (not working)
md_getrecord(provider = "pensoft", identifier = as.character(bibs[[4]]$doi))


#can also query via Mendeley database
library(RMendeley)
# https://github.com/ropensci/rmendeley

#set user options - don't know how to do this. Get apik key http://apidocs.mendeley.com/
options(MendeleyKey = "YOUR_KEY")
options(MendeleySecret = "YOUR_SECRET")

#authenticate
mc <- mendeley_auth()


msearch('authors:Alistair Boettiger published_in:Science')