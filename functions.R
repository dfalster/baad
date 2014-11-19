load_study <- function(study_name, config, verbose=FALSE) {
  if (verbose) {
    message(study_name)
  }

  filename_data_raw <- file.path("data", study_name, "data.csv")
  filename_data_opts <- file.path("data", study_name, "dataImportOptions.csv")
  filename_manipulate <- file.path("data", study_name, "dataManipulate.R")
  filename_columns <- file.path("data", study_name, "dataMatchColumns.csv")
  filename_new_data <- file.path("data", study_name, "dataNew.csv")
  filename_bib <- file.path("data", study_name, "studyRef.bib")
  filename_contact <- file.path("data", study_name, "studyContact.csv")

  data <- read_data_study(filename_data_raw,
                          filename_data_opts,
                          filename_manipulate,
                          filename_columns,
                          filename_new_data,
                          config$var_def,
                          config$conversion,
                          config$post_process)
  bibentry <- read_reference(filename_bib, study_name)
  
  list(data       = data,
       methods    = read_methods(filename_columns, config$var_def),
       bibtex     = bibentry,
       contacts   = read_contact(filename_contact),
       references = get_citation(bibentry))
}
