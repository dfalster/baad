


studyReportMd <- function(alldata, study=NULL){

  .study <- study
  .dat <- extractThisStduy(alldata, study)
  
  library(knitr)
  suppressMessages(knit2html("R/reportmd.Rmd", output=paste0("reportmd/",.study,"-report.html")))

}
  
  
