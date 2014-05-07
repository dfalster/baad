source('ms/MS-fun.R')
source('R/build-baad-fun.R')
library(plyr)
library(dataMashR)

data.path      <-  dataMashR::data.path
data           <-  loadData(reprocess=TRUE)$data
wanted         <-  contributionColumns()
contributions  <-  getContributions(data, wanted)
