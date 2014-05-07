source('R/import.R')
library(plyr)

numberOfPoints  <-  function(data, wanted) {
	contrib  <-  as.numeric(unlist(data[ , colnames(data) != 'dataset']))
	length(contrib[!is.na(contrib)])
}

expandData <-  function(data) {
	if(data$duplicates > 1) {
		newnames  <-  strsplit(data$contacts, '; ')[[1]]
		data      <-  data[rep(1, data$duplicates), ] 
		data$contacts  <-  newnames
		data
	} else {
		data
	}
}


data    <-  loadData(reprocess=TRUE)$data
vardef  <-  .mashrConfig$var.def
wanted  <-  unique(vardef$Variable[vardef$Type=='numeric'])
wanted  <-  wanted[!(wanted %in% c('map', 'mat'))]
sdata   <-  data[, c('dataset', wanted)]
conts   <-  daply(data,  .(dataset), function(x)getPersonell(unique(x$dataset)))
dbles   <-  sapply(conts, function(x)length(strsplit(x, ';')[[1]]))
npts    <-  daply(sdata, .(dataset), numberOfPoints)
allPt   <-  data.frame(study=sort(unique(data$dataset)), contacts=conts, contribution=npts, duplicates=dbles, row.names=NULL, stringsAsFactors=FALSE)

correctedData  <-  ddply(allPt, .(study), expandData)
contributions  <-  sort(tapply(correctedData$contribution, correctedData$contacts, sum), decreasing=TRUE)

