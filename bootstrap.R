#!/usr/bin/env Rscript
library(whisker)

read_templates <- function(path) {
  files <- dir(path, pattern=glob2rx("*.whisker"))
  templates <- lapply(file.path(path, files), readLines)
  names(templates) <- tools::file_path_sans_ext(files)
  templates
}

templates <- read_templates("bootstrap")

study_names <- dir("data")
vals <- list(study_names=iteratelist(study_names, value="study_name"))

str <- whisker.render(templates$maker_data.yml, vals, templates)
writeLines(str, "maker_data.yml")

str <- whisker.render(templates$maker_reports.yml, vals, templates)
writeLines(str, "maker_reports.yml")
