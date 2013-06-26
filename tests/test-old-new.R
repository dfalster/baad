library(testthat, quietly=TRUE)

ok <- system("diff -r output/data output/data-orig")

expect_that(ok, equals(0))
  
