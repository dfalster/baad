
source("R/plotting.R")
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
with(datEA, plot(log10(m.st), log10(m.lf), pch=19,cex=0.8, col=TempTrop))
legend("topleft", levels(datEA$TempTrop), pch=19, col=palette())
with(datEA, plot(log10(h.t), log10(m.lf), pch=19,cex=0.8, col=TempTrop))
with(datEA, plot(log10(d.bh), log10(m.lf), pch=19,cex=0.8, col=TempTrop))
with(datEA, plot(log10(d.bh), log10(h.t), pch=19,cex=0.8, col=TempTrop))
with(datEA, plot(log10(d.bh), log10(m.so), pch=19,cex=0.8, col=TempTrop))
with(datEA, plot(log10(h.t), log10(m.so), pch=19,cex=0.8, col=TempTrop))
with(datEA, plot(log10(m.so), log10(m.lf/m.so), pch=19,cex=0.8, col=TempTrop))
with(datEA, plot(log10(m.so), log10(a.lf/m.so), pch=19,cex=0.8, col=TempTrop))
with(datEA, plot(log10(m.so), log10(a.lf/m.lf), pch=19,cex=0.8, col=TempTrop))
with(datEA, plot(log10(m.rt), log10(m.so), pch=19,cex=0.8, col=TempTrop))
with(datEA, plot(log10(m.rt), log10(m.lf), pch=19,cex=0.8, col=TempTrop))

},"analysis/output/figures/Trop_vs_temp_plots.pdf",width=7,height=7)



#-------------------------------------------------------------------------------------------#


# Allometry plot as in Wolf

x <- studyWithVars(dat, c("m.st","m.lf","h.t"))

# how many species per study
nspecies <- sapply(x, function(arg)length(unique(arg$species)))
this1 <- nspecies==1

y <- x[[this1[1]]]
y <- y[complete.cases(y),]


sm_mlf <- sma(m.lf ~ h.t, log="xy", data=y)
sm_mst <- sma(m.st ~ h.t, log="xy", data=y)

p_mlf <- coef(sm_mlf)
p_mst <- coef(sm_mst)

r <- range(y$h.t)
ht <- seq(r[1],r[2],length=101)

mlfs <- 10^(p_mlf[1] + p_mlf[2]*ht)
msts <- 10^(p_mst[1] + p_mst[2]*ht)
mtot <- mlfs+msts

plot(ht, mlfs/mtot, type='l', ylim=c(0,1))
points(ht, (mlfs+msts)/mtot, type='l')












