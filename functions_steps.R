## These are the cleaning steps:
read_data_study <- function(study_name, config, verbose=FALSE) {
  if (verbose) {
    message(study_name)
  }

  data <- read_data_raw(study_name, config)
  data <- manipulate_data(data, study_name, config)
  data <- convert_data(data, study_name, config)
  data <- add_all_columns(data, config)
  data <- add_new_data(data, study_name, config)
  data <- fix_types(data, config)
  data <- config$post_process(data)

  filename <- data_filename(study_name, config)
  dir.create(dirname(filename), showWarnings=FALSE, recursive=TRUE)
  write.csv(data, filename, row.names=FALSE)

  data
}

read_data_raw <- function(study_name, config) {
  opts <- read_data_raw_import_options(study_name, config)
  filename <- file.path(config$dir_data, study_name, opts$name)
  read.csv(filename,
           ## Special options:
           header=opts$header, skip=opts$skip, na.strings=opts$na.strings,
           ## Shared options:
           check.names=FALSE, stringsAsFactors=FALSE, strip.white=TRUE)
}

## If the `dataManipulate.R` file is present within a study's data
## directory, it must contain the function `manipulate`.  Otherwise we
## return the identity function to indicate no manipulations will be
## done.  The function must take a data.frame as an argument and
## return one as the return value, but this is not checked at present.
##
## TODO: This needs modifying to deal with scoping issues more
## carefully.
manipulate_data <- function(data, study_name, config) {
  filename <- file.path(config$dir_data, study_name, "dataManipulate.R")
  manipulate <- get_function_from_source("manipulate", filename, identity)
  manipulate(data)
}

## Convert data to desired format, changing units, variable names
convert_data <- function(data, study_name, config) {
  var_match <- read_match_columns(study_name, config)
  var_match <- var_match[!is.na(var_match$var_out), ]

  data <- rename_columns(data, var_match$var_in, var_match$var_out)
  
  info <- column_info(config)

  ## Change units
  to_check <- intersect(names(data), var_match$var_out)
  to_check <- to_check[info$type[to_check] == "numeric"]
  
  for (col in to_check) {
    unit_from <- var_match$unit_in[match(col, var_match$var_out)[[1]]]
    unit_to <- info$units[[col]]
    if (unit_from != unit_to) {
      ## TODO: This is absolutely horrible and should change.
      x <- data[[col]]
      i <- (config$conversion$unit_in == unit_from &
            config$conversion$unit_out == unit_to)
      expr <- config$conversion$conversion[i]
      data[[col]] <- eval(parse(text=expr))
    }
  }

  data
}

## Standardise data columns to match standard template.
##
## May add or remove columns of data as needed so that all sets have
## the same columns.
add_all_columns <- function(data, config) {
  na_vector <- function(type, n) {
    rep(list(character=NA_character_, numeric=NA_real_)[[type]], n)
  }

  info <- column_info(config)
  missing <- setdiff(info$variable, names(data))
  if (length(missing) != 0) {
    extra <- as.data.frame(lapply(info$type[missing], na_vector, nrow(data)),
                           stringsAsFactors = FALSE)
    data <- cbind(data[names(data) %in% info$variable], extra)
  } else {
    data <- data[names(data) %in% info$variable]
  }
  data[info$variable]
}

## Modifies data by adding new values from table studyName/dataNew.csv
##
## Within the column given by `newVariable`, replace values that match
## `lookupValue` within column `lookupVariable` with the value
## `newValue`.  If `lookupVariable` is `NA`, then replace all elements
## of `newVariable` with the value `newValue`. Note that
## lookupVariable can be the same as newVariable.
add_new_data <- function(data, study_name, config) {
  filename <- file.path(config$dir_data, study_name, "dataNew.csv")
  import <- read.csv(filename, stringsAsFactors=FALSE, strip.white=TRUE)
  if (nrow(import) > 0) {
    import$lookupVariable[import$lookupVariable == ""] <- NA
  }
  
  if (!is.null(import)) {
    for (i in seq_len(nrow(import))) {
      col_to <- import$newVariable[i]
      col_from <- import$lookupVariable[i]
      if (is.na(col_from)) {
        # apply to whole column
        data[col_to] <- import$newValue[i]
      } else {
        ## apply to subset
        rows <- data[[col_from]] == import$lookupValue[i]
        data[rows, col_to] <- import$newValue[i]
      }
    }
  }

  data
}

## Ensures variables have correct type
fix_types <- function(data, config) {
  var_def <- config$var_def
  for (i in seq_along(var_def$variable)) {
    v <- var_def$variable[i]
    data[[v]] <- match.fun(paste0("as.", var_def$type[i]))(data[[v]])
  }
  data
}

