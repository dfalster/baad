
# Quick summary of :
# - what is contained in the dataset (tables by important groupings)
# - MAT, MAP space; comparison of WorldClim against user-supplied values
# - World maps of observations

source("R/plotting.R")
source("R/remko_functions.R")
# dat <- readRDS("cache/allomdata_post.rds")

# Sample size
nrow(dat)

# nr of species
length(unique(dat$species))

# nr of datasets
length(unique(dat$dataset))

# Table of growing condition
xtabs(~ growingCondition, data=dat)

# Family
sort(xtabs(~ family, data=dat),T)

# Vegetation and plant functional type
ftable(xtabs(~ vegetation + pft, data=dat))


#-------------------------------------------------------------------------------------#

# User supplied MAP (mm) and MAT (degC) vs. values obtained from Worldclim.
to.pdf(
  with(dat,{
    
    par(mfrow=c(1,2))
    plot(MAP, map, xlab="MAP - WorldClim", ylab="MAP - User supplied")
    abline(0,1)
    plot(MAT, mat, xlab="MAT - WorldClim", ylab="MAT - User supplied")
    abline(0,1)
    
  }), file="analysis/output/figures/MAP_MAT_Worldclim_user.pdf", width=8, height=4)

#-------------------------------------------------------------------------------------#

# Map with studies; bubble size by nr of observations
to.pdf(drawWorldPlot(dat, horlines=FALSE, sizebyn=TRUE),
       "analysis/output/figures/worldplot_sizebyn.pdf", width=10, height=7)

# Maps by vegetation type; separately.
plotveg <- function(veg, main, pchcol){

  fn <- paste0("analysis/output/figures/worldplot_sizebyn_",veg,".pdf")
  
  data <- subset(dat, vegetation == veg)
  
  to.pdf({
    drawWorldPlot(data, horlines=FALSE, sizebyn=TRUE, pchcol=pchcol)
    title(main=main)
  },
  fn, width=10, height=7)
}

plotveg("BorF","Boreal Forest","blue")
plotveg("Sav","Savannah","brown")
plotveg("TempF","Temperate forest","forestgreen")
plotveg("TempRF", "Temperate rainforest", "darkolivegreen3")
plotveg("TropRF", "Tropical rainforest", "dodgerblue2")
plotveg("TropSF", "Tropical seasonal forest", "navajowhite4")
plotveg("Wo", "Woodland", "lightgoldenrod3")




