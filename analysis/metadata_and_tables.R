
source("R/plotting.R")
source("R/remko_functions.R")
# dat <- readRDS("cache/allomdata_post.rds")

# Sample size
nrow(dat)

# nr of species
length(unique(dat$species))



# User supplied MAP (mm) and MAT (degC) vs. values obtained from Worldclim.
to.pdf(
with(dat,{
  
  par(mfrow=c(1,2))
  plot(MAP, map, xlab="MAP - WorldClim", ylab="MAP - User supplied")
  abline(0,1)
  plot(MAT, mat, xlab="MAT - WorldClim", ylab="MAT - User supplied")
  abline(0,1)
  
}), file="analysis/output/figures/MAP_MAT_Worldclim_user.pdf", width=8, height=4)



# Family
sort(xtabs(~ family, data=dat),T)

# Vegetation and plant functional type
ftable(xtabs(~ vegetation + pft, data=dat))

#


# map with studies; bubble size by nr of observations
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


# Comparisons to be made:
#-------------------------------------------------------------------------------------------#
#- Five major families (5 most common families in this dataset)
majorfam <- c("Pinaceae","Myrtaceae","Fagaceae","Betulaceae","Dipterocarpaceae")
dat5fam <- droplevels(subset(dat, family %in% majorfam))

# Family vs. PFT
ftable(xtabs(~ family + pft, data=dat5fam))

# Family vs. vegetation
ftable(xtabs(~ family + vegetation, data=dat5fam))

# But note,
sum(is.na(dat$family)) # 1342


#-------------------------------------------------------------------------------------------#
# status; does it affect LMF


#-------------------------------------------------------------------------------------------#
# crown ratio; effect on LMF

dh <- studyWithVars(dat, c("h.c","h.t","m.lf","c.d"))
dh$dataset_species <- with(dh, paste(dataset,species,sep="_"))

# now select only rows that have h.t as well as c.d
dh <- subset(dh, !is.na(h.t) & !is.na(c.d) & c.d > 0)


sm1 <- sma(m.lf ~ c.d * dataset_species, data=dh, log='xy')
sm2 <- sma(m.lf ~ h.t * dataset_species, data=dh, log='xy')

plot(sm1, type='l', col="black")
plot(sm2, type='l', col="black")



#-------------------------------------------------------------------------------------------#
# Does SLA affect leaf/stem/root scaling?


x <- studyWithVars(dat, c("m.st","m.lf","a.lf","h.t"))
x$dataset_species <- paste0(x$dataset,"_",x$species)

x$SLA <- with(x, a.lf / m.lf)
with(x, plot(log10(SLA), log(m.lf/(m.lf+m.st))))




z <- studyWithVars(dat, c("status","m.lf","m.st"))
with(z[sample(nrow(z)),],
     plot(log10(m.lf) ~ log10(m.st), pch=19, col=as.factor(status)))

#-------------------------------------------------------------------------------------------#
# MAT effects on LMF?

require(nlme)
dataset <- studyWithVars(dat, c("m.lf", "m.so", "MAT"))
dataset <- subset(dataset, m.lf > 0 & m.so > 0 & !is.na(MAT) & !is.na(m.lf) & !is.na(m.so))
dataset$dataset_species <- as.factor(with(dataset, paste(dataset,species,sep="_")))
lme1 <- lme(log10(m.lf) ~ log10(m.so), data=dataset, 
            random=~1|dataset_species, na.action=na.omit, method="ML")
lme2 <- lme(log10(m.lf) ~ log10(m.so)*MAT, data=dataset, 
            random=~1|dataset_species, na.action=na.omit, method="ML")

# MAT is significant (but so what?)
anova(lme2)


# Fit all datasets with common slope, use coefficient as indicator of size-corrected LMF.
Slope <- fixed.effects(lme1)[[2]]
dfr <- as.data.frame(do.call(rbind, lapply(split(dataset, dataset$dataset_species), function(x){
  
  a <- x$m.lf/(x$m.so^Slope)
  mat <- mean(x$MAT)
  return(c(b0=mean(a), MAT=mat))
  
})))






#-------------------------------------------------------------------------------------------#
# Tropical vs. temperate evergreen angiosperm:
# Both are large groups, do they have similar allometry or does climate influence biomass proportions
# at a given size?

datEA <- droplevels(subset(dat, pft == "EA" & vegetation %in% c("TempF","TempRF","TropRF","TropSF")))

with(datEA, plot(as.factor(vegetation), MAP))
with(datEA, plot(as.factor(vegetation), MAT))

datEA$TempTrop <- as.factor(ifelse(datEA$vegetation %in% c("TempF","TempRF"), "Temp", "Trop"))


# Randomize rows for plotting
datEA <- datEA[sample(nrow(datEA)),]

palette(c("blue","red"))
# some quick plots
to.pdf({
with(datEA, {
plot(log10(m.st), log10(m.lf), pch=19,cex=0.8, col=TempTrop)
legend("topleft", levels(datEA$TempTrop), pch=19, col=palette())
plot(log10(h.t), log10(m.lf), pch=19,cex=0.8, col=TempTrop)
plot(log10(d.bh), log10(m.lf), pch=19,cex=0.8, col=TempTrop)
plot(log10(d.bh), log10(h.t), pch=19,cex=0.8, col=TempTrop)
plot(log10(d.bh), log10(m.so), pch=19,cex=0.8, col=TempTrop)
plot(log10(h.t), log10(m.so), pch=19,cex=0.8, col=TempTrop)
plot(log10(m.so), log10(m.lf/m.so), pch=19,cex=0.8, col=TempTrop)
plot(log10(m.so), log10(a.lf/m.so), pch=19,cex=0.8, col=TempTrop)
plot(log10(m.so), log10(a.lf/m.lf), pch=19,cex=0.8, col=TempTrop)
plot(log10(m.rt), log10(m.so), pch=19,cex=0.8, col=TempTrop)
plot(log10(m.rt), log10(m.lf), pch=19,cex=0.8, col=TempTrop)
})

},"analysis/output/figures/Trop_vs_temp_plots.pdf",width=7,height=7)





