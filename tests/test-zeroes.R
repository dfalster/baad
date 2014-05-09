source('helper-test.R')

context("Zeroes")

test_that("zeroes", {
  baad <- readRDS("../output/baad.rds")

  var.def <- read.csv("../config/variableDefinitions.csv",
                      stringsAsFactors=FALSE)
  vars <- var.def$Variable[var.def$Type == "numeric"]

  for(v in vars){
    # This function finds its things via lexical scope, which is
    # global here.  A bit naughty, but it works.
    has_no_zeros <- function() {
      function(x) {
        fails <- x == 0 & !is.na(x)
        studies <- paste(unique(baad$data$dataset[fails]),
                         collapse=", ")
        expectation(!any(fails),
                    sprintf("%s: %d fails from %s", v, sum(fails), studies))
      }
    }
    fails <- baad$data[[v]] == 0
    expect_that(baad$data[[v]], has_no_zeros())
  }
})
