library(testthat)

exclude  <-  function(x, pattern){
  ex  <-  grep(pattern, names(x))
  if(length(ex)==0){
    ex  <-  -1*(1:length(names(x)))
  }
  ex
}

compareOldNew<-function(name){
  cat(name, " ")
  
  #load files for comparison
  old<-read.csv(paste0("output/data-orig/", name, ".csv"), stringsAsFactors=F)
  new<-read.csv(paste0("output/data/", name, ".csv"), stringsAsFactors=F)
  
  #remove methods variables
  old  <-  old[,-1*exclude(old,"method")]
  new  <-  new[,-1*exclude(new,"method")]
  
  #remove reference variables
  old  <-  old[,-1*exclude(old, "reference")]
  new  <-  new[,-1*exclude(new,"reference")]
  
  #only keep names in final variable list
  old  <-  data.frame(old[,names(old)%in%var.def$Variable])
  new  <-  data.frame(new[,names(new)%in%var.def$Variable])
  
#  browser()
  #only compare columns in original file
  expect_that(old, equals(new[,names(old)]))  
}

