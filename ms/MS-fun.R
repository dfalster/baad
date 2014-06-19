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
	readStudyFile(studyName, "studyContact.csv")[,"name", drop=TRUE]
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

getCitation <-  function(studyName) {
	i <- baad$references$studyName==studyName
	citation <- baad$references$citation[i]

	if(baad$references$doi[i] !=""){
		citation <- paste0(citation, " DOI: [", baad$references$doi[i], "](http://doi.org/",baad$references$doi[i],").")
	} else if( baad$references$url[i] != ""){
		citation <- paste0(citation, " [Link](", baad$references$url[i],").")
	}
	citation
}

removeNAcols <- function(dfr, exclude = c("empty")){

  out <- dfr[, !names(dfr)%in% exclude]
  out[,sapply(out, function(x)!all(is.na(x)))]

}

getLatLon <- function(data){
	uniquesites <- data[-duplicated(paste(data$longitude, data$latitude))]
	pasteC(sprintf("%3.2f, %3.2f", as.numeric(uniquesites$latitude), as.numeric(uniquesites$longitude)),';  ')
}

studyDetails  <-  function(data) {

	template <-
    	c('## {{studyName}}',
    	'Data from: {{citation}}\n',
      	'1. Site Description',
      	'\t- Site(s) type(s): {{siteType}}',
      	'\t- Geography',
      	'\t\t- latitudes, longitude: {{latlon}}',
		'\t- Site(s) history: {{siteHistory}}',
 	    '2. Experimental or sampling design',
		'\t- Design characteristics: {{metadataDesign}}',
 	    '\t- Variables included: {{vars}}',
 	    '3. Research methods',
		'\t- {{lab}}',
		'4. Study contacts: {{personell}}'
      	)

  	template <- paste(template, collapse="\n")
  	whisker.render(template,
                 list(studyName=data$studyName[1],
                      siteType=pasteC(getVegType(unique(data$vegetation)),'; '),
                      latlon=getLatLon(data),
                      siteHistory=pasteC(getSiteHistory(unique(data$growingCondition)),'; '),
           	          metadataDesign=getMetadataDesign(unique(data$studyName)),
           	          lab=getMetadataMethods(unique(data$studyName)),
           	          personell=pasteC(getPersonell(unique(data$studyName))),
           	          citation=getCitation(data$studyName[1]),
           	          vars=pasteC(names(removeNAcols(data,
           	          	exclude = c("studyName","species","speciesMatched","location", "latitude","longitude","vegetation","map","mat","family","pft","growingCondition", "grouping"))), ", ")
                 ))
}


getLastName  <-  function(authorNames) {
		sapply(authorNames, function(x){
									a <- strsplit(x,' ', useBytes=TRUE)[[1]]
									a[length(a)]
							})
	}

lisOfAuthors  <-  function(data) {
	firstAuthors   <-  c('Daniel S. Falster', 'Remko A. Duursma', 'Masae Ishihara', 'Diego R. Barneche', 'Rich G. FitzJohn', 'Angelica Vårhammar')
	dataAuthors <- unique(do.call(c, lapply(unique(data$studyName), getPersonell)))

	dataAuthors <- dataAuthors[!dataAuthors %in% firstAuthors]
	pasteC(c(firstAuthors, dataAuthors[order(getLastName(dataAuthors))]), ', ')
}


