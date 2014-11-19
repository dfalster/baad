## This is designed to mimic the current assembly, and will change
## considerably.
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
  variable_definitions <- read_csv("config/variableDefinitions.csv")
  conversions <- read_csv("config/variableConversion.csv")

  study_names <- dir("data")

  d <- lapply(study_names, load_study_helper,
              variable_definitions, conversions)
  names(d) <- study_names

  for (i in seq_along(d)) {
    d[[i]]$bibtex <- set_bib_key(d[[i]]$bibtex, study_names[[i]])
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

  ret$data <- fix_types(ret$data, variable_definitions)
  ret$bibtex <- do.call("c", unname(lapply(d, "[[", "bibtex")))
  ret$dictionary <- variable_definitions

  ret
}
