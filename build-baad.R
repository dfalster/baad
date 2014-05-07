#!/usr/bin/env Rscript
source('R/build-baad-fun.R')
dat <- loadData(reprocess=FALSE)
saveRDS(dat, "output/baad.rds")
