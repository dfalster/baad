get_function_from_source <- function(name, filename, default=NULL) {
  e <- new.env()
  if (file.exists(filename)) {
    source(filename, local=e)
  }
  if (exists(name, envir=e)) {
    get(name, mode="function", envir=e)
  } else if (is.function(default)) {
    default
  } else {
    stop(sprintf("Expected function '%s' within %s", name, filename))
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
