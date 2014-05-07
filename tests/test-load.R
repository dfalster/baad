source('helper-test.R')

context("Loading data")

## Check ode state get/set:
test_that("Data loads", {

  # Intentional fail
  expect_that(loadStudy("wrongname", reprocess= TRUE),  throws_error())

  # check each study loads
  for(s in getStudyNames())
    expect_that(loadStudy(s, reprocess= TRUE),  is_a("list"))

  # load entire dataset
  dat <-loadStudies(reprocess=FALSE)
  expect_that(dat,  is_a("list"))
  }
)
