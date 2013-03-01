library(testthat)

exclude  <-  function(x, pattern){
  ex  <-  grep(pattern, names(x))
  if(length(ex)==0){
    ex  <-  -1*(1:length(names(x)))
  }
  ex
}

compareOldNew<-function(name, verbose=FALSE, browse=FALSE){
  if(verbose) cat("check data ")
  
  #load files for comparison
  old<-read.csv(paste0("output/data-orig/", name, ".csv"), stringsAsFactors=FALSE)
  new<-read.csv(paste0("output/data/", name, ".csv"), stringsAsFactors=FALSE)
  
  #remove methods variables
  old  <-  old[,-1*exclude(old,"method")]
  new  <-  new[,-1*exclude(new,"method")]
  
  #remove reference variables
  old  <-  old[,-1*exclude(old, "reference")]
  new  <-  new[,-1*exclude(new,"reference")]
  
  #only keep names in final variable list
  old  <-  data.frame(old[,names(old)%in%var.def$Variable])
  new  <-  data.frame(new[,names(new)%in%var.def$Variable])

  if(browse){
    print(head(old))
    print(head(new[,names(old)])) 
    browser()
    i=2
    any(old[,i] != new[,names(old)][,i])
    
    cbind(old[,i], new[,names(old)[i]], old[,i] == new[,names(old)][,i])
  }
 
  #only compare columns in original file
  expect_that(old, equals(new[,names(old)]))
  if(verbose) cat("\n") 
}

importAndCheck<-function(studyName, verbose=FALSE, browse=FALSE){
  processStudy(studyName, verbose=verbose, browse=browse)
  compareOldNew(studyName, browse=browse, verbose=verbose)
  data
}