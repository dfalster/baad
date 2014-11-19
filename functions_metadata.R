read_data_raw_import_options <- function(study_name) {
  filename <- file.path("data", study_name,
                        "dataImportOptions.csv")
  tmp <- read.csv(filename, header=FALSE, row.names=1,
                  stringsAsFactors=FALSE)
  opts <- structure(as.list(tmp[[1]]), names=rownames(tmp))
  
  defaults <- list(na.strings="NA")

  import <- modifyList(defaults, opts)

  ## Then some processing:
  import$header <- as.logical(import$header)
  import$skip <- as.integer(import$skip)
  if (!("NA" %in% import$na.strings)) {
    import$na.strings <- c("NA", import$na.strings)
  }
  import  
}

read_reference <- function(study_name) {
  filename <- file.path("data", study_name, "studyRef.bib")
  bib <- bibtex::read.bib(filename)

  ## Hack work around to change key in bib entry (bibtex entry
  ## redefines '[' and/or '[[' in ways that cause nothing but grief)
  bib_plain <- unclass(bib)
  attr(bib_plain[[1]], "key") <- study_name
  class(bib_plain) <- "bibentry"

  bib_plain
}

read_methods <- function(study_name, variable_definitions) {
  ## TODO: Rename 'methods' to 'is_method' in 'variableDefinitions.csv'
  vars <- variable_definitions$variable[variable_definitions$methods]

  ## Fill with data from study
  var_match <- read_match_columns(study_name)

  ## Make data frame with all variables requiring methods
  methods <- data.frame(rbind(character(length(vars))), stringsAsFactors=FALSE)
  names(methods) <- vars

  to_fix <- intersect(var_match$var_out, vars)
  methods[to_fix] <- var_match$method[match(to_fix, var_match$var_out)]

  methods
}

read_match_columns <- function(study_name) {
  filename <- file.path("data", study_name, "dataMatchColumns.csv")
  ret <- read.csv(filename, stringsAsFactors=FALSE, na.strings = c("NA", ""),
                  strip.white=TRUE)
  ret[!is.na(ret$var_out), ]
}

read_contact <- function(study_name) {
  filename <- file.path("data", study_name, "studyContact.csv")
  read.csv(filename, stringsAsFactors=FALSE, strip.white=TRUE)
}

get_citation <- function(bibentry) {
  if (is.null(bibentry$doi)) {
    doi <- ""
    url <- if (is.null(bibentry$url[[1]])) "" else bibentry$url[[1]]
  } else {
    doi <- bibentry$doi[[1]]
    if (doi != "") {
      url <- paste0("http://doi.org/", doi)
    } else if (!is.null(bibentry$url)) {
      url <- bibentry$url[[1]]
    }
  }

  data.frame(doi=doi, url=url, citation=format_citation(bibentry),
             stringsAsFactors=FALSE)
}

## This is a hack that would be better done with a style.  See
## ?bibentry for directions to that rabbithole.
format_citation <- function(bibentry) {
  citation <- format(bibentry, "text")
  find <- c("<URL.+>", "<.+?>", " , .", ", .", "\n", "*", "_", "“", "”", "..",
            ",.", ". .", "'''.'", "''.")
  replace <- c("", "", ".", ".", " ", "", "", "'", "'", ".", ".", ".", "", "")
  fixed <- rep(TRUE, length(find))
  fixed[c(1, 2)] <- FALSE
  for (i in seq_along(find)) {
    citation <- gsub(find[i], replace[i], citation, fixed = fixed[i])
  }
  citation
}

column_info <- function(variable_definitions) {
  ret <- as.list(variable_definitions[c("variable", "type", "units")])
  names(ret$type) <- names(ret$units) <- ret$variable
  ret
}
