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
                 list(studyName=unique(data$studyName),
                      siteType=pasteC(getVegType(unique(data$vegetation)),'; '),
                      lon=pasteC(sprintf("%3.1f", as.numeric(unique(data$longitude))),' ; '),
                      lat=pasteC(sprintf("%3.1f", as.numeric(unique(data$latitude))),' ; '),
                      siteHistory=pasteC(getSiteHistory(unique(data$growingCondition)),'; '),
           	          metadataDesign=getMetadataDesign(unique(data$studyName)),
           	          collection='',
           	          lab=getMetadataMethods(unique(data$studyName)),
           	          personell=pasteC(getPersonell(unique(data$studyName))),
           	          citation=baad$references$citation[baad$references$studyName==data$studyName[1]]
                 ))

}


getLastName  <-  function(authorNames) {
		sapply(authorNames, function(x){
									a <- strsplit(x,' ', useBytes=TRUE)[[1]]
									a[length(a)]
							})
	}

lisOfAuthors  <-  function(data) {
	firstAuthors   <-  c('Daniel Falster', 'Remko A. Duursma', 'Masae Ishihara', 'Diego R. Barneche', 'Rich FitzJohn', 'Angelica Vårhammar')
	dataAuthors <- unique(do.call(c, lapply(unique(data$studyName), getPersonell)))

	dataAuthors <- dataAuthors[!dataAuthors %in% firstAuthors]
	pasteC(c(firstAuthors, dataAuthors[order(getLastName(dataAuthors))]), ', ')
}


