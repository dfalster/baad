

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


