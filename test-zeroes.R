source('helper-test.R')

context("Zeroes")

test_that("zeroes", {

  dat <- loadStudies(reprocess=FALSE)

  vars  <-  mashrDetail("var.def")$Variable[mashrDetail("var.def")$Type=="numeric"]

  for(v in vars){
    fails <- dat$data[[v]] == 0
    expect_that(sum(fails, na.rm=TRUE), equals(0), info = paste0(v,": ", sum(fails, na.rm=TRUE)," fails from ", paste0(unique(dat$data[["dataset"]][!is.na(fails) & fails]), collapse=", ")))
  }
}
)
