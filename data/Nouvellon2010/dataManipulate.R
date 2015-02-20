manipulate <- function(raw) {
  
  
  raw$grouping <- makeGroups(raw, "contributor")
  
  # Relevel the 'status' variable, which is now coded like this:
  # Numbered from smaller to larger, corresponding to size class of the inventory
  # (where 0 = suppressed).See notes in original data.csv.
  # Here , relevel them so that 0=0, and max(status)=3, with rest in between based on cutting it in bins.
  # This is done separately for each collection date, because the original data did that as well.
  # (RAD)
  stat <- do.call(c,lapply(split(raw, raw$contributor), 
                           function(x)as.character(cut(x$status/max(x$status),
                                                       seq(0,1,length.out=5),
                                                       include.lowest=TRUE,
                                                       labels=as.character(0:3)))))
  raw$status <- unname(stat)
  
  raw
}

