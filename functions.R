load_study <- function(study_name, config, verbose=FALSE) {
  bibentry <- read_reference(study_name)

  list(data       = read_data_study(study_name, config, verbose),
       methods    = read_methods(study_name, config$var_def),
       bibtex     = bibentry,
       contacts   = read_contact(study_name),
       references = get_citation(bibentry))
}
