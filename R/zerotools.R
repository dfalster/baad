zsub <- function(x)droplevels(d$data[d$data[[x]] == 0,])

getMin <- function(d){
  
  vardef <- read.csv("config/variableDefinitions.csv", stringsAsFactors=FALSE)
  numvars <- vardef$Variable[vardef$Type == "numeric"]
  
  Min <- function(x){
    X <- as.numeric(d$data[[x]])
    if(all(is.na(X)))
      return(NA)
    else
      return(min(X, na.rm=T))
  }
  
  s <- sapply(numvars, Min)
  data.frame(Variable=names(s), Minimum=as.vector(s))
}

# 
# d <- loadStudies(reprocess=TRUE)
# getMin(d)