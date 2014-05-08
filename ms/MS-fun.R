## Mimic dataMashR function here, but relative to *this* directory.
data.path <- function(...) {
  file.path("../data", ...)
}

pasteAndCollapse  <-  function(values, binder) {
	paste0(unique(values), collapse=binder)
}

readStudyFile  <-  function(studyName, File) {
	read.csv(data.path(studyName, File), header = TRUE, 
        na.strings = c(NA,''), stringsAsFactors = FALSE, strip.white = TRUE)
}

getMetadataDesign  <-  function(studyName) {
	metadata  <-  readStudyFile(studyName, "studyMetadata.csv")
	metadata$Description[metadata$Topic=='Sampling strategy']
}

getMetadataMethods  <-  function(studyName) {
	metadata  <-  readStudyFile(studyName, "studyMetadata.csv")
	if(nrow(metadata) > 0) {
		metadata  <-  metadata[!is.na(metadata$Description) & !(tolower(metadata$Topic) %in% c('sampling strategy', 'age', 'growth environment')),]
		pasteAndCollapse(paste0(metadata$Topic, ': ', metadata$Description), '\n\t\t\t')
	}
}

getPersonell  <-  function(studyName) {
	pasteAndCollapse(unique(readStudyFile(studyName, "studyContact.csv")$name), '; ')
}


class2Bdetails  <-  function(data) {

	template <-
    	c('## {{studyName}}',
      	'\t1. Site Description',
      	'\t\ta. Site(s) type(s)',
      	'\t\t{{siteType}}',
      	'\t\tb. Geography',
      	'\t\t\tlongitude(s):',
		'\t\t\t\t{{lon}}',
      	'\t\t\tlatitudes(s):',
		'\t\t\t\t{{lat}}',
		'\t\tc. Site(s) history',
		'\t\t\t{{siteHistory}}',
 	    '\t2. Experimental or sampling design',
		'\t\ta. Design characteristics',
		'\t\t\t{{metadataDesign}}',
		'\t\tb. Data collection period, frequency:',
		'\t\t\t{{collection}}',
 	    '\t3. Research methods',
		'\t\ta. Field Laboratory',
		'\t\t\t{{lab}}',
		'\t4. Project personnel:',
		'\t\t{{personell}}'
      	)
  	
  	template <- paste(template, collapse="\n") # might not be needed
  	whisker.render(template,
                 list(studyName=unique(data$dataset),
                      siteType=pasteAndCollapse(unique(data$vegetation),' ; '),
                 	  lon=pasteAndCollapse(unique(data$longitude),' ; '),
                 	  lat=pasteAndCollapse(unique(data$latitude),' ; '),
           	          siteHistory=pasteAndCollapse(unique(data$growingCondition),' ; '),
           	          metadataDesign=getMetadataDesign(unique(data$dataset)),
           	          collection='',
           	          lab=getMetadataMethods(unique(data$dataset)),
           	          personell=getPersonell(unique(data$dataset))
                 ))

}

numberOfPoints  <-  function(data, wanted) {
	sum(apply(data[ , colnames(data) != 'dataset'], 2, function(x)length(x[!is.na(x)])))
}

expandData <-  function(data) {
	if(data$duplicates > 1) {
		newnames       <-  strsplit(data$contacts, '; ')[[1]]
		data           <-  data[rep(1, data$duplicates), ] 
		data$contacts  <-  newnames
		data
	} else {
		data
	}
}

contributionColumns  <-  function(vardef) {
	wanted  <-  unique(vardef$Variable[vardef$Type=='numeric'])
	wanted[!(wanted %in% c('map', 'mat'))]
}

filterData4Contributions  <-  function(data, contributionCols) {
	data[, c('dataset', contributionCols)]
}

listContacts  <-  function(data) {
	daply(data,  .(dataset), function(x)getPersonell(unique(x$dataset)))
}

numberOfContacts  <-  function(data) {
	sapply(data, function(x)length(strsplit(x, ';')[[1]]))
}

numberOfcontributions  <-  function(data) {
	daply(data, .(dataset), numberOfPoints)
}

correctData  <-  function(data) {
	ddply(data, .(study), expandData)
}

getContributions  <-  function(data, ...) {
	sdata   <-  filterData4Contributions(data, ...)
	conts   <-  listContacts(data)
	dbles   <-  numberOfContacts(conts)
	npts    <-  numberOfcontributions(sdata)
	
	allPt   <-  data.frame(study=sort(unique(data$dataset)), contacts=conts, contribution=npts, duplicates=dbles, row.names=NULL, stringsAsFactors=FALSE)
	
	correctedData  <-  correctData(allPt)
	sort(tapply(correctedData$contribution, correctedData$contacts, sum), decreasing=TRUE)
}

orderByLastName  <-  function(authorNames) {
	sapply(authorNames, function(x){a<-strsplit(x,' ')[[1]];a[length(a)]})
}

lisOfAuthors  <-  function(alphabetical=TRUE, ...) {
	wanted         <-  contributionColumns(...)
	contributions  <-  getContributions(data, wanted)
	firstAuthors   <-  'Daniel Falster, Remko Duursma, Diego R. Barneche, Rich Fitzjohn, Angelica Vårhammar'
	if(alphabetical) {
		pasteAndCollapse(c(firstAuthors, names(contributions)[order(orderByLastName(names(contributions)))]), ', ')
	} else {
		pasteAndCollapse(c(firstAuthors, names(contributions)), ', ')
	}
}


