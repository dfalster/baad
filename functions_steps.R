## These are the cleaning steps:
read_data_study <- function(filename_data_raw,
                            filename_data_opts,
                            filename_manipulate,
                            filename_columns,
                            filename_new_data,
                            variable_definitions,
                            conversions,
                            post_process) {
  data <- read_data_raw(filename_data_raw, filename_data_opts)
  data <- manipulate_data(data, filename_manipulate)
  data <- convert_data(data, filename_columns, variable_definitions, conversions)
  data <- add_all_columns(data, variable_definitions)
  data <- add_new_data(data, filename_new_data)
  data <- fix_types(data, variable_definitions)
  ## TODO: move this up out of this function
  data <- post_process(data)
  data
}

read_data_raw <- function(filename, filename_opts) {
  opts <- read_data_raw_import_options(filename_opts)
  read_csv(filename,
           header=opts$header, skip=opts$skip, na.strings=opts$na.strings)
}

## If the `dataManipulate.R` file is present within a study's data
## directory, it must contain the function `manipulate`.  Otherwise we
## return the identity function to indicate no manipulations will be
## done.  The function must take a data.frame as an argument and
## return one as the return value, but this is not checked at present.
##
## TODO: This needs modifying to deal with scoping issues more
## carefully.
manipulate_data <- function(data, filename_manipulate) {
  manipulate <- get_function_from_source("manipulate", filename_manipulate, identity)
  manipulate(data)
}

## Convert data to desired format, changing units, variable names
convert_data <- function(data, filename_columns, variable_definitions, conversions) {
  var_match <- read_match_columns(filename_columns)

  data <- rename_columns(data, var_match$var_in, var_match$var_out)
  
  info <- column_info(variable_definitions)

  ## Change units
  to_check <- intersect(names(data), var_match$var_out)
  to_check <- to_check[info$type[to_check] == "numeric"]
  
  for (col in to_check) {
    unit_from <- var_match$unit_in[match(col, var_match$var_out)[[1]]]
    unit_to <- info$units[[col]]
    if (unit_from != unit_to) {
      ## TODO: This is absolutely horrible and should change.
      x <- data[[col]]
      i <- (conversions$unit_in == unit_from &
            conversions$unit_out == unit_to)
      data[[col]] <- eval(parse(text=conversions$conversion[i]))
    }
  }

  data
}

## Standardise data columns to match standard template.
##
## May add or remove columns of data as needed so that all sets have
## the same columns.
add_all_columns <- function(data, variable_definitions) {
  na_vector <- function(type, n) {
    rep(list(character=NA_character_, numeric=NA_real_)[[type]], n)
  }

  info <- column_info(variable_definitions)
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
add_new_data <- function(data, filename) {
  import <- read_csv(filename)
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
fix_types <- function(data, variable_definitions) {
  var_def <- variable_definitions
  for (i in seq_along(var_def$variable)) {
    v <- var_def$variable[i]
    data[[v]] <- match.fun(paste0("as.", var_def$type[i]))(data[[v]])
  }
  data
}

