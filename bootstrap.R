#!/usr/bin/env Rscript
library(whisker)

study_names <- dir("data")
vals <- list(study_names=iteratelist(study_names, value="study_name"))

str <- whisker.render(readLines("config/remake_data.yml.whisker"), vals)
writeLines(str, "remake_data.yml")

str <- whisker.render(readLines("config/remake_reports.yml.whisker"), vals)
writeLines(str, "remake_reports.yml")
