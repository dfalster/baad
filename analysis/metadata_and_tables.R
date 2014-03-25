
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
# 
# # Maps by vegetation type; separately.
# plotveg <- function(veg, main, pchcol){
# 
#   fn <- paste0("analysis/output/figures/worldplot_sizebyn_",veg,".pdf")
#   
#   data <- subset(dat, vegetation == veg)
#   
#   to.pdf({
#     drawWorldPlot(data, horlines=FALSE, sizebyn=TRUE, pchcol=pchcol)
#     title(main=main)
#   },
#   fn, width=10, height=7)
# }
# 
# plotveg("BorF","Boreal Forest","blue")
# plotveg("Sav","Savannah","brown")
# plotveg("TempF","Temperate forest","forestgreen")
# plotveg("TempRF", "Temperate rainforest", "darkolivegreen3")
# plotveg("TropRF", "Tropical rainforest", "dodgerblue2")
# plotveg("TropSF", "Tropical seasonal forest", "navajowhite4")
# plotveg("Wo", "Woodland", "lightgoldenrod3")

windows(10,7)
# Colored by vegetation type
cols <- c("blue","brown","forestgreen","darkorange","dodgerblue2","navajowhite4","lightgoldenrod3")
vegs <- c("BorF","Sav","TempF","TempRF","TropRF","TropSF","Wo")
vegs_labels <- c("Boreal forest","Savannah","Temperate forest","Temperate rainforest","Tropical rainforest",
                 "Tropical seasonal forest","Woodland")
to.pdf({
  drawWorldPlot(dat[dat$vegetation == vegs[1],], horlines=FALSE, sizebyn=TRUE, pchcol=cols[1])
  for(i in 2:length(vegs)){
    drawWorldPlot(dat[dat$vegetation == vegs[i],], horlines=FALSE, sizebyn=TRUE, pchcol=cols[i], add=TRUE)
  }
  par(xpd=NA)
  legend(-160, -100, vegs_labels[1:3], fill=cols[1:3], bty='n')
  legend(-90, -100, vegs_labels[4:7], fill=cols[4:7], bty='n')
  
}, "analysis/output/figures/worldmap_coloredbyveg.pdf", width=10, height=7)



# Table of variables and nr of observations.
nr <- function(x)sum(!is.na(dat[,x]))
cfg <- read.csv("config/variabledefinitions.csv")

vars <- c("m.st","m.so","m.lf","a.lf","m.rt","h.t","c.d","d.bh", "ma.ilf","r.st")
nrdf <- data.frame(Variable=vars, nobs=unname(sapply(vars,nr)))

nrdf <- merge(nrdf, cfg[,c("Variable","label")])
write.csv(nrdf, "analysis/output/data/nrobstable.csv")


