manipulate <- function(raw){


  raw$grouping <- makeGroups(raw, "stem.ha-1")

  # removed from dataMatchColumns
  # d.ccm,p1,cm2,d.c,
  # a.shbhcm2,p1,cm2,a.ssbh,
  raw$astbc <- with(raw, (pi/4)*d.ccm^2)
    
  #   dominanceclass,,,status,"6 dominant, 4&5 codominant, 2&3 intermediate, 
  # 1 suppressed: based on sample from 6 points in total stand diameter 
  # distribution"
  
  # Convert lat and long
  x <- strsplit(gsub("MS","",raw$latitude),"D")
  raw$latitude <- -sapply(x, function(z)as.numeric(z[1]) + as.numeric(z[2])/60)
  
  x <- strsplit(gsub("ME","",raw$longitude),"D")
  raw$longitude <- sapply(x, function(z)as.numeric(z[1]) + as.numeric(z[2])/60)
  
  
  
raw
}
