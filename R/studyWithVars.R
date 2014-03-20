
removeNAcols <- function(dfr){
  
  dfr[,sapply(dfr, function(x)!all(is.na(x)))]
  
} 


studyWithVars <- function(allom, hasVars, returnwhat=c("list","dataframe")){
  
  r <- require(plyr)
  if(!r)stop("Install plyr package first.")
  returnwhat <- match.arg(returnwhat)
  l <- split(allom, allom$dataset)
  l <- lapply(l, removeNAcols)
  ihasvars <- sapply(l, function(x) all(hasVars %in% names(x)))

  if(sum(ihasvars) == 0){
    message("No datasets have values in all those columns.")
    return(NA)
  } else {
    message("Your query returned ",sum(ihasvars)," studies.")
    if(returnwhat=="list")
      return(l[ihasvars])
    else
      return(rbind.fill(l[ihasvars]))
  }

}


