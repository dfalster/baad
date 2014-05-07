library(gdata, quietly=TRUE)
library(bibtex, quietly=TRUE)

bibGetElement <- function(bibfile, element = "doi", i=1){
  bibs <- read.bib(bibfile)
  unclass(bibs[[i]])[[1]][[element]]
}

formatBib <- function(bibfile,
                      initialSep=".",
                      fieldSep=". "
                      ){

  bibs <- read.bib(bibfile)
  
  
  f <- lapply(bibs, function(b){
    
    b <- unclass(b)[[1]]
    
    # strip html tags in title (typically <i> etc.):
    tit <- gsub("<.+?>","",b$title)
    Encoding(tit) <- "UTF-8"  #allows for funny characters
    
    # author initials
    a <- unclass(b$author)
    
    # family name
    family <- unlist(sapply(a, "[[", "family"))
    # extra unlist is necessary for NULL elements
    
    Encoding(family) <- "UTF-8"
    
    # Extract initials from given names
    given <- lapply(a, "[[", "given")
    initials <- lapply(given, function(x){
      
      # If initials only, they are in {}
      if(any(grepl("}",x,fixed=TRUE))){
        cl <- gsub("{","",x,fixed=TRUE)
        cl <- gsub("}","",cl,fixed=TRUE)
        cl <- gsub(".","",cl,fixed=TRUE)
        
        init <- strsplit(cl, "")[[1]]
        return(init)
      } else {  
        substr(x,1,1)
      }
    })
    
    
    initials <- unname(sapply(initials, function(x){
      paste0(paste(x, collapse=initialSep),initialSep)
      }))
    
    # author names
    p <- paste(family, initials, collapse=", ")
    
    # field separator, unless it is identical to the initial separator
    if(trim(fieldSep) != trim(initialSep))
      p <- paste0(p, fieldSep)
    else
      p <- paste0(p, " ")
    
    # year
    p <- paste0(p, b$year, fieldSep)
    
    # title
    p <- paste0(p, tit, fieldSep)
    
    # journal name
    jour <- b$journal
    Encoding(jour) <- "UTF-8"
    p <- paste0(p, jour, fieldSep)
    
    # not sure how often this happens ... double '-'
    pag <- gsub("--","-",b$pages)
    Encoding(pag) <- "UTF-8"  # allows for long -
    
    # volume and page numbers
    p <- paste0(p, b$volume,":",pag)
  
  return(p)
  })
  
  
return(f)
}
