read_data_processed <- function(studyName, ...) {
  process_study(studyName, ...)
}

data_filename <- function(study_name, config) {
  file.path(config$dir_out, "cache", paste0(study_name, ".csv"))
}

load_study <- function(study_name, config, verbose=FALSE) {
  bibentry <- read_reference(study_name, config)

  list(data       = read_data_study(study_name, config, verbose),
       methods    = read_methods(study_name, config),
       bibtex     = bibentry,
       contacts   = read_contact(study_name, config),
       references = get_citation(bibentry))
}
