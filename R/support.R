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

last <- function(x) {
  x[[length(x)]]
}

## Make colours semitransparent:
make_transparent <- function(col, opacity=0.5) {
  if (length(opacity) > 1 && any(is.na(opacity))) {
    n <- max(length(col), length(opacity))
    opacity <- rep(opacity, length.out = n)
    col <- rep(col, length.out = n)
    ok <- !is.na(opacity)
    ret <- rep(NA, length(col))
    ret[ok] <- Recall(col[ok], opacity[ok])
    ret
  } else {
    tmp <- col2rgb(col)/255
    rgb(tmp[1, ], tmp[2, ], tmp[3, ], alpha = opacity)
  }
}

capitalize <- function (string) {
  capped <- grep("^[^A-Z]*$", string, perl = TRUE)
  substr(string[capped], 1, 1) <- toupper(substr(string[capped], 1, 1))
  string
}

write_csv <- function(data, filename) {
  write.csv(data, filename, row.names=FALSE)
}
