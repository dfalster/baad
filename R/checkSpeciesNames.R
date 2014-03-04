


dat <-d$data
species <- sort(unique(dat$species))


#-------------------------------------------------------------------------------------#
# Taxonstand

library(Taxonstand)

# This takes a while.
# Note we have to use try() because TPL fails to exit nicely when a species does not exist.
tpl <- lapply(species, function(x)try(TPL(x, corr=TRUE)))

f <- function(x){
  
  if(inherits(x, "try-error"))
    return(NA)
  else
    return(paste(x$New.Genus, x$New.Species))
  
}
species_new <- sapply(tpl,f)


species_dfr <- data.frame(species_old=species, species_new_Taxonstand=species_new,
                          stringsAsFactors=FALSE)
species_dfr$Corrected_Taxonstand <- ifelse(species_dfr$species_new_Taxonstand == species_dfr$species_old, "", "Fixed")




#-------------------------------------------------------------------------------------#
# taxize

# Same as above, gnr_resolve is also not robust. If I send all species names,
# it throws a mysterious error. 
# Takes quite a long time.
# txz <- lapply(species, function(x)try(gnr_resolve(x)))
# it returns too much, and when it does not properly match you get lots of strange responses.
# Use just the ones that Taxonstand could not do. 
sp_miss <- species_dfr$species_old[is.na(species_dfr$species_new)]

txz <- lapply(sp_miss, function(x)try(gnr_resolve(x, stripauthority=TRUE)))
  
# grab the matched name if they are all the same, otherwise grab the one that was the same as 
# the submitted one. Because in this particular case, they are all the same except for one,
# which was correct anyway (Psychotria gracilifora).
sp_fixed <- sapply(txz, function(x){
  
  if(nlevels(x$matched_name2) == 1)
    return(levels(x$matched_name2)[1])
  else
    return(levels(x$submitted_name)[1])
  
})

species_dfr2 <- data.frame(species_old = sp_miss, species_new_taxize = sp_fixed,
                           stringsAsFactors=FALSE)
species_dfr2$Corrected_taxize <- ifelse(species_dfr2$species_new_taxize == species_dfr2$species_old, "", "Fixed")

species_dfr <- merge(species_dfr, species_dfr2, all=TRUE)


# EXPORT
write.csv(species_dfr, "config/speciesCheckTable_Taxonstand_taxize.csv", row.names=FALSE)






  
  