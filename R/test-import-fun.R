library(testthat)

exclude  <-  function(x, pattern){
  ex  <-  grep(pattern, names(x))
  ex
}
compareOldNew<-function(name){
  old<-read.csv(paste0("output/data-orig/", name, ".csv"), stringsAsFactors=F)
  new<-read.csv(paste0("output/data/", name, ".csv"), stringsAsFactors=F)
  cat(name, " ")
  old  <-  old[,-exclude(old,"method")]
  new  <-  new[,-exclude(new,"method")]
  expect_that(old, equals(new))  
}



