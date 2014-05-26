## Mimic dataMashR function here, but relative to *this* directory.
data.path <- function(...) {
  file.path("../data", ...)
}

#Paste and collapse
pasteC  <-  function(values, binder="\n") {
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
		pasteC(paste0(metadata$Topic, ': ', metadata$Description), '\n\t- ')
	}
}

getPersonell  <-  function(studyName) {
	pasteC(unique(readStudyFile(studyName, "studyContact.csv")$name), ', ')
}

getSiteHistory <-function(code){
	llply(code, function(x)
		switch(x,
			FW = "field wild",
			FE = "field experimental",
			GH = "glasshouse",
			PU = "plantation unmanaged",
			PM = "plantation managed",
			GC = "growth chamber",
			CG = "common garden",
			""
			)
		)
}

getVegType <-function(code){
	llply(code, function(x)
		switch(x,
			Sav = "Savannah",
			TropRF = "Tropical rainforest",
			TempRF = "Temperate rainforest",
			TropSF = "Tropical seasonal forest",
			TempF = "Temperate forest",
			BorF = "Boreal forest",
			Wo = "Woodland",
			Gr = "Grassland",
			Sh = "Shrubland",
			De = "Desert",
			""
			)
		)
}

class2Bdetails  <-  function(data) {

	template <-
    	c('## {{studyName}}',
    	'Data from: {{citation}}\n',
      	'1. Site Description',
      	'\t- Site(s) type(s): {{siteType}}',
      	'\t- Geography',
      	'\t\t- longitude(s): {{lon}}',
      	'\t\t- latitudes(s): {{lat}}',
		'\t- Site(s) history: {{siteHistory}}',
 	    '2. Experimental or sampling design',
		'\t- Design characteristics: {{metadataDesign}}',
		'\t- Data collection period, frequency: {{collection}}',
 	    '3. Research methods',
		'\t- {{lab}}',
		'4. Study contacts: {{personell}}'
      	)

  	template <- paste(template, collapse="\n")
  	whisker.render(template,
                 list(studyName=unique(data$dataset),
                      siteType=pasteC(getVegType(unique(data$vegetation)),'; '),
                 	  lon=pasteC(unique(format(data$longitude, digits=4)),' ; '),
                 	  lat=pasteC(unique(format(data$latitude, digits=4)),' ; ')
,
           	          siteHistory=pasteC(getSiteHistory(unique(data$growingCondition)),'; '),
           	          metadataDesign=getMetadataDesign(unique(data$dataset)),
           	          collection='',
           	          lab=getMetadataMethods(unique(data$dataset)),
           	          personell=getPersonell(unique(data$dataset)),
           	          citation=baad$references$citation[baad$references$dataset==data$dataset[1]]
                 ))

}

numberOfPoints  <-  function(data, wanted) {
	sum(apply(data[ , colnames(data) != 'dataset'], 2, function(x)length(x[!is.na(x)])))
}

expandData <-  function(data) {
	if(data$duplicates > 1) {
		newnames       <-  strsplit(data$contacts, ', ')[[1]]
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
	sapply(data, function(x)length(strsplit(x, ',')[[1]]))
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

lisOfAuthors  <-  function(alphabetical=TRUE, ...) {
	wanted         <-  contributionColumns(...)
	contributions  <-  getContributions(data, wanted)
	firstAuthors   <-  c('Daniel Falster', 'Remko Duursma', 'Masae Ishihara', 'Diego R. Barneche', 'Rich FitzJohn', 'Angelica Vårhammar')
	contributions  <-  contributions[!(names(contributions) %in% firstAuthors)]

	getLastName  <-  function(authorNames) {
		sapply(authorNames, function(x){
									a <- strsplit(x,' ')[[1]]
									a[length(a)]
							})
	}

	if(alphabetical) {
		pasteC(c(firstAuthors, names(contributions)[order(getLastName(names(contributions)))]), ', ')
	} else {
		pasteC(c(firstAuthors, names(contributions)), ', ')
	}
}


