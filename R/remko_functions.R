# Argument allomdata comes from:
# allomdata <- loadStudies(reprocess=TRUE)
postProcessAllom <- function(allomdata){
  
  # To make sure variable types are the same as in the config/variableDefinitions file, do;
  message("Fixing variable type")
  dat <- fixType(allomdata)
  
  # Fill missing derived variables (e.g. m.so= m.st+m.lf, etc.)
  message("Filling derived variables")
  dat <- fillDerivedVariables(dat)
  
  # Add fixed species name. These were generated in R/checkSpeciesNames. 
  # The code is slow, so we read the results here.
  # <<apologies for ugly code here; will be moved elsewhere - RAD>>
  message("Adding fixed species names")
  specdfr <- read.csv("config/speciesCheckTable_Taxonstand_taxize.csv",stringsAsFactors=FALSE)
  specdfr$species_Fixed <- specdfr$species_new_Taxonstand
  ii <- is.na(specdfr$species_Fixed)
  specdfr$species_Fixed[ii] <- specdfr$species_new_taxize[ii]
  specdfr <- specdfr[,c("species_old","species_Fixed")]
  names(specdfr)[1] <- "species"
  dat <- merge(dat, specdfr, all=TRUE)
  
  # Get MAT and MAP from Worldclim
  message("Looking up MAP and MAT from WorldClim")
  
  # Mean annual T (returns 12-column matrix)
  usecache <- TRUE
  
  # For now, this only works on Remko's computer:
  # I have the worldclim layers downloaded locally; it is many times faster that way.
  # Only have to do this once anyway.
  if(!usecache){
    sapply(c("raster","dismo","XML","rgdal"),checkPackage)
    
    # Dataframe with unique lat-long's.
    dfr <- dat[,c("latitude","longitude")]
    dfr$latitude <- as.numeric(dfr$latitude)
    dfr$longitude <- as.numeric(dfr$longitude)
    
    dfr$latlongkey <- paste(dfr$latitude,dfr$longitude)
    dfr <- dfr[!duplicated(dfr$latlongkey),]
    dfr <- dfr[complete.cases(dfr),]
    
    MAT <- getWorldClim(dfr$longitude, dfr$latitude, "tmean")
    dfr$MAT <- apply(MAT/10,1,mean, na.rm=TRUE)
    # note: MAT was in units of 10C.
    
    MAP <- getWorldClim(dfr$longitude, dfr$latitude, "prec")
    dfr$MAP <- apply(MAP,1,sum, na.rm=TRUE)
    
    dfr$MAP[is.na(dfr$MAT)] <- NA
    
    saveRDS(dfr, "cache/worldclim.rds")
  } else{
    dfr <- readRDS("cache/worldclim.rds")
  }
  
  # Merge
  dat$latlongkey <- with(dat, paste(latitude, longitude))
  dat <- merge(dat, dfr[,c("latlongkey","MAP","MAT")], all=TRUE) 
  
  # Delete some garbage
  dat <- within(dat,{
    ii <- NULL
    latlongkey <- NULL
  })
  
  # reorder
  dat<- dat[moveme(names(dat), "MAP after map; MAT after mat; dataset first; species_Fixed after species")]
  return(dat)
}



removeNAcols <- function(dfr){
  
  dfr[,sapply(dfr, function(x)!all(is.na(x)))]
  
} 


studyWithVars <- function(allom, hasVars, returnwhat=c("dataframe","list")){
  
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




addlogaxes <- function(Xfrom=1, Xto=1000, Yfrom=0.01, Yto=100, addX=T, addY=T,
                       tck1=-0.05, tck2=-0.01, labeltype=1){
  
  p <- log10(Xfrom):log10(Xto)
  z <- log10(Yfrom):log10(Yto)
  
  if(labeltype == 1){
    Labels <- lapply(p, function(x)substitute(expression(10^p), list(p=x)))
    Labels <- do.call("c", Labels)
  }
  if(labeltype == 2)Labels <- 10^p
  
  # Major ticks at X-axis
  if(addX)axis(1, at=p,labels=Labels, tck=tck1)
  
  # Minor ticks X-axis
  ps <- c()
  for(i in 1:(length(p)-1))ps <- c(ps, seq(10^p[i],10^p[i+1],length=10))
  if(addX)axis(1,log10(ps),labels=F,tck=tck2)
  
  # Major ticks at Y-axis
  
  if(labeltype == 1){
    Labels <- lapply(z, function(x)substitute(expression(10^z), list(z=x)))
    Labels <- do.call("c", Labels)
  }
  if(labeltype == 2)Labels <- 10^z
  
  if(addY)axis(2, at=z,labels=Labels, tck=tck1)
  
  # Minor ticks Y-axis
  zs <- c()
  for(i in 1:(length(z)-1))zs <- c(zs, seq(10^z[i],10^z[i+1],length=10))
  if(addY)axis(2,log10(zs),labels=F,tck=tck2)
  box()
}




#grabbed from stackoverflow:
#http://stackoverflow.com/questions/3369959/moving-columns-within-a-data-frame-without-retyping

#'@examples
#'\dontrun{
#'
#'moveme(names(df), "g first")
# moveme(names(df), "g first; a last; e before c")
# Of course, using it to reorder the columns in your data.frame is straightforward:
#   
#   df[moveme(names(df), "g first")]
# And for data.tables (moves by reference, no copy) :
#   
#   setcolorder(dt, moveme(names(dt), "g first"))
#'}
moveme <- function (invec, movecommand) {
  movecommand <- lapply(strsplit(strsplit(movecommand, ";")[[1]], 
                                 ",|\\s+"), function(x) x[x != ""])
  movelist <- lapply(movecommand, function(x) {
    Where <- x[which(x %in% c("before", "after", "first", 
                              "last")):length(x)]
    ToMove <- setdiff(x, Where)
    list(ToMove, Where)
  })
  myVec <- invec
  for (i in seq_along(movelist)) {
    temp <- setdiff(myVec, movelist[[i]][[1]])
    A <- movelist[[i]][[2]][1]
    if (A %in% c("before", "after")) {
      ba <- movelist[[i]][[2]][2]
      if (A == "before") {
        after <- match(ba, temp) - 1
      }
      else if (A == "after") {
        after <- match(ba, temp)
      }
    }
    else if (A == "first") {
      after <- 0
    }
    else if (A == "last") {
      after <- length(myVec)
    }
    myVec <- append(temp, values = movelist[[i]][[1]], after = after)
  }
  myVec
}





getWorldClim <- function(longitude, latitude, varname, worldclim_dataloc = "c:/data/worldclim"){
  
  
  
  here <- data.frame(lon=longitude,lat=latitude)
  coordinates(here) <- c("lon", "lat")
  proj4string(here) <- CRS("+proj=longlat +datum=WGS84")
  
  coors <- SpatialPoints(here)
  
  extractVar <- function(varname, where, ind=1:12){
    p <- list()
    
    dir <- paste0(worldclim_dataloc,"/",varname,"/")
    
    vars <- paste0(varname,"_", ind)
    
    for (i in 1:length(vars)){
      a <- raster(paste0(dir,vars[i]))
      dataVal <- extract(a,where)
      p[[i]] <- dataVal
    }
    outvars <- do.call(cbind,p)
    names(outvars) <- vars
    return(outvars)
  }
  
  tmeans <- extractVar(varname, coors)
  
  return(matrix(tmeans, ncol=12))
}




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



fillDerivedVariables <- function(x){
  
  x <- within(x, {
    c.d <- as.numeric(c.d)
    m.rt <- as.numeric(m.rt)
    a.cp <- as.numeric(a.cp)
    d.cr <- as.numeric(d.cr)
    
    # Missing leaf area when leaf mass and LMA are OK.
    ii <- is.na(a.lf) & !is.na(m.lf) & !is.na(ma.ilf)
    a.lf[ii] <- m.lf[ii] / ma.ilf[ii] 
    
    # Height to crown base if tree height and crown depth are OK.
    ii <- is.na(h.c) & !is.na(c.d) & !is.na(h.t)
    h.c[ii] <- h.t[ii] - c.d[ii]
    
    # Stem area  / DBH at breast height or base.
    ii <- is.na(a.stbh) & !is.na(d.bh)
    a.stbh[ii] <- (pi/4)*d.bh[ii]^2
    
    ii <- is.na(a.stba) & !is.na(d.ba)
    a.stba[ii] <- (pi/4)*d.ba[ii]^2
    
    # Again, the other way around.
    ii <- !is.na(a.stbh) & is.na(d.bh)
    d.bh[ii] <- sqrt(a.stbh[ii] / (pi/4))
    
    ii <- !is.na(a.stba) & is.na(d.ba)
    d.ba[ii] <- sqrt(a.stba[ii] / (pi/4))
    
    # Stem mass
    ii <- is.na(m.st) & !is.na(m.ss) & !is.na(m.sh) & 
      !is.na(m.sb)
    m.st[ii] <- m.ss[ii] + m.sh[ii] + m.sb[ii]
    
    # total aboveground mass.
    ii <- is.na(m.so) & !is.na(m.lf) & !is.na(m.st)
    m.so[ii] <- m.lf[ii] + m.st[ii]
    
    # total root mass
    ii <- is.na(m.rt) & !is.na(m.rf) & !is.na(m.rc)
    m.rt[ii] <- m.rf[ii] + m.rc[ii]
    
    # Total mass.
    ii <- is.na(m.to) & !is.na(m.rt) & !is.na(m.so)
    m.to[ii] <- m.rt[ii] + m.so[ii]
    
    # crown width
    ii <- is.na(d.cr) & !is.na(a.cp)
    d.cr[ii] <- sqrt(a.cp[ii]/(pi/4))
    
    # crown area
    ii <- !is.na(d.cr) & is.na(a.cp)
    a.cp[ii] <- (pi/4)*d.cr[ii]^2
  })
  
  return(x)  
}
