
fixType <- function(dfr, cfg="config/variableDefinitions.csv"){
  
  
  cfg <- read.csv(cfg, stringsAsFactors=FALSE)
  
  for(i in seq_along(cfg$Variable)){
    
    v <- cfg$Variable[i]
    tp <- cfg$Type[i]
    
    typeFun <- switch(tp,
                 numeric = as.numeric,
                 character = as.character)
    
    pre_nrNA <- sum(is.na(dfr[,v]))
    dfr[,v] <- typeFun(dfr[,v])
    post_nrNA <- sum(is.na(dfr[,v]))
    if(post_nrNA > pre_nrNA)
      message("Variable : ",v," now contains ", post_nrNA, " missing values.")
    
  }
  
return(dfr)
}