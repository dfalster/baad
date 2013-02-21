raw        <-  raw[raw$Source == "Osada (2005) Canadian Journal of Botany", ]
raw$species=raw$species
raw$grouping=paste(raw$Source, raw$Tree.No., sep="; ")
