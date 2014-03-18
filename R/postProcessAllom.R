# Argument allomdata comes from:
# allomdata <- loadStudies(reprocess=TRUE)
postProcessAllom <- function(allomdata){

  # To make sure variable types are the same as in the config/variableDefinitions file, do;
  message("Fixing variable type")
  source("R/fixType.R")
  dat <- fixType(allomdata)
  
  # Fill missing derived variables (e.g. m.so= m.st+m.lf, etc.)
  message("Filling derived variables")
  source("R/fillDerivedVariables.R")
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
    source("R/getWorldClim.R")
    source("R/checkPackage.R")
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
  source("R/moveme.R")
  dat<- dat[moveme(names(dat), "MAP after map; MAT after mat; dataset first; species_Fixed after species")]
  return(dat)
}

