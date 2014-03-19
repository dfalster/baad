
removeNAcols <- function(dfr){
  
  dfr[,sapply(dfr, function(x)!all(is.na(x)))]
  
} 


studyWithVars <- function(allom, hasVars){
  
  
  l <- split(allom, allom$dataset)
  l <- lapply(l, removeNAcols)
  ihasvars <- sapply(l, function(x) all(hasVars %in% names(x)))

  if(sum(ihasvars) == 0){
    message("No datasets have values in all those columns.")
    return(NA)
  } else {
    message("Your query returned ",sum(ihasvars)," studies.")
    return(l[ihasvars])
  }

}


