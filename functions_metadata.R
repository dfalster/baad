read_data_raw_import_options <- function(filename) {
  tmp <- read_csv(filename, header=FALSE, row.names=1)
  opts <- structure(as.list(tmp[[1]]), names=rownames(tmp))
  
  import <- modifyList(list(na.strings="NA"), opts)

  ## Then some processing:
  import$header <- as.logical(import$header)
  import$skip <- as.integer(import$skip)
  import$na.strings <- union("NA", import$na.strings)

  import  
}

read_reference <- function(filename, study_name) {
  bib <- bibtex::read.bib(filename)

  ## Hack work around to change key in bib entry (bibtex entry
  ## redefines '[' and/or '[[' in ways that cause nothing but grief)
  bib_plain <- unclass(bib)
  attr(bib_plain[[1]], "key") <- study_name
  class(bib_plain) <- "bibentry"

  bib_plain
}

read_methods <- function(filename_columns, variable_definitions) {
  ## TODO: Rename 'methods' to 'is_method' in 'variableDefinitions.csv'
  vars <- variable_definitions$variable[variable_definitions$methods]

  ## Fill with data from study
  var_match <- read_match_columns(filename_columns)

  ## Make data frame with all variables requiring methods
  methods <- data.frame(rbind(character(length(vars))), stringsAsFactors=FALSE)
  names(methods) <- vars

  to_fix <- intersect(var_match$var_out, vars)
  methods[to_fix] <- var_match$method[match(to_fix, var_match$var_out)]

  methods
}

read_match_columns <- function(filename) {
  ret <- read_csv(filename, na.strings = c("NA", ""))
  ret[!is.na(ret$var_out), ]
}

get_citation <- function(bibentry) {
  if (is.null(bibentry$doi)) {
    doi <- ""
    url <- if (is.null(bibentry$url[[1]])) "" else bibentry$url[[1]]
  } else {
    doi <- bibentry$doi[[1]]
    url <- paste0("http://doi.org/", doi)
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
