# Paste together list of var_names and their values, used for
# aggregating varnames into 'grouping' variable NOTE: Used in
# dataManipulate.R
makeGroups <- function(data, var_names) {
  apply(cbind(data[, var_names]), 1, function(x)
        ## jsonlite::toJSON(as.list(x), auto_unbox=TRUE)
        paste(var_names, "=", x, collapse = "; "))
}
