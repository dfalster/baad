## This is designed to mimic the current assembly, and will change
## considerably.
make_config <- function() {
  config <- list()
  config$var_def <- read_csv("config/variableDefinitions.csv")
  config$conversions <-
    read_csv("config/variableConversion.csv")
  config$post_process <-
    get_function_from_source("postProcess", "config/postProcess.R",
                             identity)
  config
}

build_baad <- function(verbose=TRUE) {
  config <- make_config()
  study_names <- dir("data")
  d <- lapply(study_names, load_study, config, verbose)
  names(d) <- study_names

  # combine into single object
  combine <- function(name, d) {
    ret <- plyr::ldply(d, function(x) x[[name]])
    rename_columns(ret, ".id", "studyName")
  }
  ret <- list(data=combine("data", d),
              methods=combine("methods", d),
              contacts=combine("contacts", d),
              references=combine("references", d))

  ret$data <- fix_types(ret$data, config)  
  ret$bibtex <- do.call("c", unname(lapply(d, "[[", "bibtex")))
  ret$dictionary <- config$var_def

  ret
}
