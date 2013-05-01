

formatBib <- function(bibfile,
                      initialSep=".",
                      fieldSep=". "
                      ){
  
  require(gdata)
  require(bibtex)
  
  b <- unclass(read.bib(bibfile))[[1]]
  
  
  # strip html tags in title (typically <i> etc.):
  tit <- gsub("<.+?>","",b$title)
  
  
  # author initials
  a <- unclass(b$author)
  
  given <- lapply(a, "[[", "given")
  family <- sapply(a, "[[", "family")
  
  initials <- lapply(given, function(x)substr(x,1,1))
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
  p <- paste0(p, b$journal, fieldSep)
  
  # not sure how often this happens ... double '-'
  
  # volume and page numbers
  pag <- gsub("--","-",b$pages)
  p <- paste0(p, b$volume,":",pag)
  
return(p)
}



