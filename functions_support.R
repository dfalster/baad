get_function_from_source <- function(name, filename, default=identity) {
  e <- new.env()
  if (file.exists(filename)) {
    source(filename, local=e)
  }
  if (exists(name, envir=e)) {
    get(name, mode="function", envir=e)
  } else {
    default
  }
}

rename_columns <- function(obj, from, to) {
  names(obj)[match(from, names(obj))] <- to
  obj
}

read_csv <- function(...) {
  read.csv(..., stringsAsFactors=FALSE, check.names=FALSE,
           strip.white=TRUE)
}

## Hack work around to change key in bib entry (bibtex entry
## redefines '[' and/or '[[' in ways that cause nothing but grief)
set_bib_key <- function(bib, key) {
  bib_plain <- unclass(bib)
  attr(bib_plain[[1]], "key") <- key
  class(bib_plain) <- "bibentry"
  bib_plain
}
