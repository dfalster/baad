
## This is checking that is specific to the baad data set
postProcess <- function(data, lookupSpecies="none"){
  
  fillDerivedVariables <- function(x){
    
    x <- within(x, {
      c.d <- as.numeric(c.d)
      m.rt <- as.numeric(m.rt)
      a.cp <- as.numeric(a.cp)
      d.cr <- as.numeric(d.cr)
      
      # Missing leaf area when leaf mass and LMA are OK.
      ii <- is.na(a.lf) & !is.na(m.lf) & !is.na(ma.ilf)
      a.lf[ii] <- m.lf[ii] / ma.ilf[ii] 
      
      # Missing leaf mass when leaf area and LMA are OK.
      ii <- !is.na(a.lf) & is.na(m.lf) & !is.na(ma.ilf)
      m.lf[ii] <- a.lf[ii] * ma.ilf[ii] 
      
      # Height to crown base if tree height and crown depth are OK.
      ii <- is.na(h.c) & !is.na(c.d) & !is.na(h.t)
      h.c[ii] <- h.t[ii] - c.d[ii]
      
      # Crown depth if tree height and height to crown base are OK
      ii <- is.na(c.d) & !is.na(h.t) & !is.na(h.c)
      c.d[ii] <- h.t[ii] - h.c[ii]
      
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
      
      # clean up
      ii <- NULL
    })
    
    x
  }
  
  checkSpeciesNames <- function(data, cachefile="config/taxon_updates.csv",
                                newVarName="speciesMatched",
                                lookupWhich=c("none","missingonly","all")
  ){
    
    species <- sort(unique(as.character(data$species)))
    lookupWhich <- match.arg(lookupWhich)
    
    r1 <- require(Taxonstand)
    r2 <- suppressPackageStartupMessages(require(taxize))
    r3 <- require(jsonlite)
    
    if(!all(r1,r2,r3)){
      warning("Not looking up species names; install Taxonstand, taxize and jsonlite packages first. Using cache.")
      lookupWhich <- "none"
    }
    if(!file.exists(cachefile) & lookupWhich != "all"){
      warning("cachefile not found. Set lookupWhich='all' to match all.")
      return(data)
    }
    
    if(lookupWhich == "missingonly")
      stop("Not implemented yet. Try 'all' or 'none'.")
    
    if(lookupWhich != "all"){
      species_dfr <- read.csv(cachefile, stringsAsFactors=FALSE)
      #       species <- setdiff(species, cache$speciesMatched)
    }
    
    if(lookupWhich != "none"){
      
      #---- Taxonstand
      
      # Note we have to use try() because TPL fails to exit nicely when a species does not exist (!).
      options(show.error.messages=FALSE)
      starttime <- proc.time()[3]
      sink(tempfile())
      tpl <- lapply(species, function(x)try(TPL(x, corr=TRUE)))
      sink()
      endtime <- proc.time()[3]
      message("Taxonstand query completed in ", round((endtime-starttime)/60,1)," minutes.")
      options(show.error.messages=TRUE)
      
      # Make species name out of returned object (or NA when not found).
      f <- function(x){  
        if(inherits(x, "try-error"))
          return(NA)
        else{
          if(x$Plant.Name.Index){
            #             hasVar <- !(x$New.Infraspecific %in% c("NA",""))
            #             Var <- if(hasVar) paste("var.",x$New.Infraspecific) else ""
            
            return(paste(x$New.Genus, x$New.Species))  #, Var))
          } else {
            return(NA)
          }
          
        }
      }
      species_new <- sapply(tpl,f)
      species_dfr <- data.frame(species=species, species_new_Taxonstand=species_new,
                                stringsAsFactors=FALSE)
      
      #---- taxize
      
      # gnr_resolve() is also not robust. If I send all species names, it throws a mysterious error. 
      # Try this yourself:
      # txz <- lapply(species, function(x)try(gnr_resolve(x)))
      # it returns too much, and when it does not properly match you get lots of strange responses.
      # Might have to revisit this when/if taxize is updated in the future.
      # Here we lookup just the ones that Taxonstand could not do. 
      sp_miss <- species_dfr$species[is.na(species_dfr$species_new_Taxonstand)]
      
      starttime <- proc.time()[3]
      txz <- lapply(sp_miss, function(x)try(gnr_resolve(x, stripauthority=TRUE)))
      endtime <- proc.time()[3]
      message("taxize completed in ", round((endtime-starttime)/60,1)," minutes.")
      
      # Grab the matched name if they are all the same, otherwise grab the one that was the same as 
      # the submitted one. Because in this particular case, they are all the same except for one,
      # which was correct anyway (Psychotria gracilifora). Again, this is a fix of unexpected behaviour
      # by taxize.
      sp_fixed <- sapply(txz, function(x){
        
        if(nlevels(x$matched_name2) == 1)
          return(levels(x$matched_name2)[1])
        else
          return(levels(x$submitted_name)[1])
        
      })
      
      # Results for taxize
      species_dfr_taxize <- data.frame(species = sp_miss, species_new_taxize = sp_fixed,
                                       stringsAsFactors=FALSE)
      
      # Dataframe with Taxonstand, taxize results.
      species_dfr <- merge(species_dfr, species_dfr_taxize, all=TRUE)
      
      # Variable species_Fixed in cache is from Taxonstand, or taxize when Taxonstand
      # returned NA.
      species_dfr$speciesMatched <- with(species_dfr, 
                                         ifelse(is.na(species_new_Taxonstand),species_new_taxize,species_new_Taxonstand))
      
      # Write cache
      write.csv(species_dfr, cachefile, row.names=FALSE)
      
    } else {
      species_dfr <- read.csv(cachefile, stringsAsFactors=FALSE)
    }
    
    dfr <- species_dfr[,c("species","speciesMatched")]
    
    # Some cleaning up:
    # 'unknown' species
    unk <- c(grep("unknown",dfr$species,ignore.case=TRUE),
             grep("unidentified",dfr$species,ignore.case=TRUE))
    dfr$speciesMatched[unk] <- "Unknown"
    
    # sp. is dropped in speciesMatched
    nc <- sapply(strsplit(dfr$speciesMatched, " "),length)
    dfr$speciesMatched[nc==1 & dfr$speciesMatched != "Unknown"] <-
      paste(dfr$speciesMatched[nc==1 & dfr$speciesMatched != "Unknown"], "sp.")

    # Find hybrids; don't match names
    hyb <- c(grep("[*]", dfr$species),
             grep(" x ", dfr$species))
    dfr$speciesMatched[hyb] <- dfr$species[hyb]
    
    # Merge onto full dataset
    names(dfr)[2] <- newVarName 
    data <- merge(data, dfr, by="species")
    
    # Reshuffle; new species next to species
    s <- match("species",names(data))
    n <- ncol(data)
    data <- data[,c(1:s,n,(s+1):(n-1))]
    
    return(data)
  }
  
  # Fill missing derived variables (e.g. m.so= m.st+m.lf, etc.)
  data <- fillDerivedVariables(data)
  
  # Add matched species name.
  data <- checkSpeciesNames(data, lookupWhich=lookupSpecies)
  
  
  return(data)  
}

