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
             path("studyMetadata.csv"),
             variable_definitions,
             conversions)
}

build_baad <- function(verbose=TRUE) {
  variable_definitions <- read_csv("config/variableDefinitions.csv")
  conversions <- read_csv("config/variableConversion.csv")

  study_names <- dir("data")

  d <- lapply(study_names, load_study_helper,
              variable_definitions, conversions)
  combine_baad(d=d, variable_definitions=variable_definitions)
}

combine_baad <- function(..., d=list(...), variable_definitions) {
  combine <- function(name, d) {
    ret <- plyr::ldply(d, function(x) x[[name]])
    rename_columns(ret, ".id", "studyName")
  }
  names(d) <- sapply(d, "[[", "key")
  ret <- list(data=combine("data", d),
              methods=combine("methods", d),
              contacts=combine("contacts", d),
              references=combine("references", d),
              metadata=combine("metadata", d))

  ret$bibtex <- do.call("c", unname(lapply(d, "[[", "bibtex")))
  ret$dictionary <- variable_definitions
  ret
}
