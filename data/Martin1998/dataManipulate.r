raw$N.lf   <-  (raw$N.lf/100)*raw$LMA #transforms from percentage to the units of LMA so it can later be converted into kg/m2
raw$species=raw$spp, raw$grouping=paste("Filter = ", raw$Filter, sep="")
