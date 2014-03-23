
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

d <- studyWithVars(dat, c("h.c","h.t","m.lf"))

# why not the same?
with(d, plot(h.t-h.c, c.d))


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





