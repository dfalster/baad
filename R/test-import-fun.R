library(testthat)

exclude  <-  function(x, pattern){
  ex  <-  grep(pattern, names(x))
  if(length(ex)==0){
    ex  <-  -1*(1:length(names(x)))
  }
  ex
}

compareOldNew<-function(name){
  #load files for comparison
  old<-read.csv(paste0("output/data-orig/", name, ".csv"), stringsAsFactors=F)
  new<-read.csv(paste0("output/data/", name, ".csv"), stringsAsFactors=F)
  cat(name, " ")
  old  <-  old[,-1*exclude(old,"method")]
  new  <-  new[,-1*exclude(new,"method")]
  expect_that(old, equals(new))  
}



