

formatBib <- function(bibfile,
                      initialSep=".",
                      fieldSep="."
                      ){
  
  require(gdata)
  
  r <- require(bibtex)
  if(!r)stop("Need bibtex package!")
  
  b <- unclass(read.bib(bibfile))[[1]]
  
  
  # strip html tags:
  tit <- gsub("<.+?>","",b$title)
  
  
  # author initials
  a <- unclass(b$author)
  
  given <- lapply(a, "[[", "given")
  family <- sapply(a, "[[", "family")
  
  initials <- lapply(given, function(x)substr(x,1,1))
  initials <- unname(sapply(initials, function(x){
    paste0(paste(x, collapse=initialSep),initialSep)
    }))
  
  p <- paste(family, initials, collapse=", ")
  
  lastChar <- substr(p, nchar(p),nchar(p))
  if(lastChar != fieldSep)p <- paste0(p, fieldSep)
  
  p <- paste0(p, " ")
  
  p <- paste0(p, b$year, fieldSep," ")
  
  p <- paste0(p, tit, fieldSep, " ")
  
  p <- paste0(p, b$journal, fieldSep, " ")
  
  pag <- gsub("--","-",b$pages)
  p <- paste0(p, b$volume,":",pag)
  
return(p)
}



