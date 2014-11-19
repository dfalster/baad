## This is designed to mimic the current assembly, and will change
## considerably.
make_config <- function() {
  config <- list()
  config$var_def <- read_csv("config/variableDefinitions.csv")
  config$conversions <-
    read_csv("config/variableConversion.csv")
  config$post_process <-
    get_function_from_source("postProcess", "config/postProcess.R")
  config
}

load_study_helper <- function(study_name,
                              variable_definitions,
                              conversions) {
  message(study_name)
  path <- function(x) file.path("data", study_name, x)
  load_study(path("data.csv"),
             path("dataImportOptions.csv"),
             path("dataManipulate.R"),
             path("dataMatchColumns.csv"),
             path("dataNew.csv"),
             path("studyRef.bib"),
             path("studyContact.csv"),
             variable_definitions,
             conversions)
}

build_baad <- function(verbose=TRUE) {
  config <- make_config()
  study_names <- dir("data")

  d <- lapply(study_names, load_study_helper,
              config$var_def, config$conversion)
  names(d) <- study_names

  for (i in seq_along(d)) {
    d[[i]]$bibtex <- set_bib_key(d[[i]]$bibtex, study_names[[i]])
  }

  post_process <- config$post_process
  for (i in seq_along(d)) {
    d[[i]]$data <- post_process(d[[i]]$data)
  }

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
