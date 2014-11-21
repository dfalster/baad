#!/usr/bin/env Rscript
library(whisker)

study_names <- dir("data")
vals <- list(study_names=iteratelist(study_names, value="study_name"))

str <- whisker.render(readLines("bootstrap/maker_data.yml.whisker"), vals)
writeLines(str, "maker_data.yml")

str <- whisker.render(readLines("bootstrap/maker_reports.yml.whisker"), vals)
writeLines(str, "maker_reports.yml")
