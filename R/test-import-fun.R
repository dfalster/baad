library(testthat)

compareOldNew<-function(name){
  old<-read.csv(paste0("output/data-orig/", name, ".csv"))
  new<-read.csv(paste0("output/data/", name, ".csv"))
  cat(name, " ")
  expect_that(old, equals(new))  
}



