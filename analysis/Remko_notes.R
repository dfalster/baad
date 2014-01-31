
library(gplots)
library(scales)
library(magicaxis)

source('R/import.R')  
source("R/fillDerivedvariables.R")
source("R/gamplot.R")


d <- loadStudies(reprocess=TRUE)

dat <- fillDerivedVariables(d$data)



# leaf mass / stem mass vs. size.
dfr <- droplevels(subset(dat, !is.na(m.st) & !is.na(m.lf)))
dfr <- subset(dfr, m.lf > 0)
dfr$dataset <- as.factor(dfr$dataset)
dfr$species <- as.factor(dfr$species)
dfr$pft <- as.factor(dfr$pft)
dfr <- droplevels(subset(dfr, pft != ""))
dfr$m.lf.fraction <- with(dfr, m.lf / m.so)

palette(alpha(rich.colors(nlevels(dfr$dataset)),0.4))

with(dfr, plot(log10(m.so), m.lf.fraction, axes=FALSE,
               xlab="Aboveground biomass (kg)",
               ylab="Leaf mass fraction (-)",
               pch=19, col=dataset
               ))
magaxis(side=1, unlog='x', tcl=-0.4)
axis(2)
box()

palette(alpha(rich.colors(nlevels(dfr$pft)),0.4))


dfr$log_m.so <- log10(dfr$m.so)
dfr$log_m.lf.fraction <- log10(dfr$m.lf.fraction)



with(dfr, plot(log_m.so, log_m.lf.fraction, axes=FALSE,
               xlab="Aboveground biomass (kg)",
               ylab="Leaf mass fraction (-)",
               pch=19, col=pft
))
magaxis(side=c(1,2), unlog='xy', tcl=-0.4)
box()
legend("topright", levels(dfr$pft), pch=19, col=palette())



# 
dfr <- droplevels(subset(data, !is.na(m.st) & !is.na(m.lf) & !is.na(m.rt) & 
                           m.lf > 0 & m.rt > 0 & pft != "" & 
                           m.st < m.to))
dfr$m.to <- with(dfr, m.rt + m.st + m.lf)

dfr$dataset <- as.factor(dfr$dataset)
dfr$species <- as.factor(dfr$species)
dfr$pft <- as.factor(dfr$pft)
dfr$m.lf.fraction <- with(dfr, m.lf / m.to)
dfr$m.st.fraction <- with(dfr, m.st / m.to)
dfr$m.rt.fraction <- with(dfr, m.rt / m.to)


windows(8,8)
par(mfrow=c(2,2))
plotit <- function(Pft, dataset){
  x <- subset(dataset, pft == Pft)
  with(x, plot(log10(m.to), m.rt.fraction, col="red", ylim=c(0,1.1),
               xlab="Total biomass (kg)",
               ylab="Biomass fractions (-)",
               main=Pft,
               axes=FALSE))

  magaxis(side=1, unlog='x', tcl=-0.4)
  axis(2, at=seq(0,1,by=0.2))
  box()
  with(x, points(log10(m.to), m.rt.fraction + m.lf.fraction, col="blue"))
  abline(h=1, lwd=2, col="forestgreen")
}
for(z in c("DA","EA","EG"))plotit(z,dfr)


plot(1, type='n', ann=FALSE, axes=FALSE)
legend("left", c("Root","Root+Leaf","Root+Leaf+Stem"), pch=c(19,19,-1),
                 lty=c(-1,-1,1), col=c("red","blue","forestgreen"), cex=0.8)



#----------------------------------------------------------------------------------------------#
# 3/4 scaling

data$dataset_species <- as.factor(paste(data$dataset, data$species, sep="-"))
# 
# dfr <- droplevels(subset(data, !is.na(d.cr) & !is.na(h.c) & !is.na(m.lf) &
#                                         m.lf > 0 & h.c > 0 & d.cr > 0))


sm <- sma(m.lf ~ m.to * dataset_species, data=data, log='xy')
plot(sm)
for(x in -2:0)abline(x,1)


p <- coef(sm)
p$dataset_species <- rownames(p)
rownames(p) <- NULL

meansize <- aggregate(m.to ~ dataset_species, FUN=mean, na.rm=TRUE, data=data)
p <- merge(p, meansize, all=FALSE)

with(p, plot(log10(m.to), slope, ylim=c(0,2)))
abline(lm(slope ~ log10(m.to), data=p))
abline(h=0.75, col="red")

#---------------------------------------------------------------------------------------------#

# functional balance.
dfr <- subset(data, !is.na(m.rf) & !is.na(m.lf) & pft != "")
dfr$pft <- as.factor(dfr$pft)

palette(rich.colors(4))
with(dfr, plot(log10(m.lf), log10(m.rf),
               axes=FALSE,
               xlab="Leaf biomass (kg)",
               ylab="Fine root biomass (kg)",
               pch=19,
               col=pft))
zs <- c(0.05, 0.25, 0.5, 0.75,1)
for(z in zs)abline(log10(z),1)
legend("bottomright", levels(dfr$pft), pch=19, col=palette())
magaxis(side=c(1,2), unlog='xy', tcl=-0.4)
box()


