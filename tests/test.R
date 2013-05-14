library(testthat, quietly=TRUE)

ok <- system("diff -r output.ref output")
expect_that(ok, equals(0))
  
