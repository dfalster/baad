library(testthat)
library(dataMashR)

# for debug
# options(warn=1, error=recover)

context("Check package setup")

validateConfig("config")

context("Check datasets")

for(d in dir("data"))
	validateStudy(d, "config")
