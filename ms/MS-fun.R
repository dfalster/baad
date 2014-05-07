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
		pasteAndCollapse(paste0(metadata$Topic, ': ', metadata$Description), '\n\t\t')
	}
}

getPersonell  <-  function(studyName) {
	pasteAndCollapse(unique(readStudyFile(studyName, "studyContact.csv")$name), '; ')
}


class2Bdetails  <-  function(data) {
	paste0('## ', unique(data$dataset), '\n',
		   '\t1. Site description \n',
		   '\ta. Site(s) type(s) ', '\n\t\t',               pasteAndCollapse(unique(data$vegetation),' ; '),       '\n',
		   '\tb. Geography ',       '\n\t\tlongitude(s): ', pasteAndCollapse(unique(data$longitude),' ; '),        '\n',
		                            '\t\tlatitude(s): ',    pasteAndCollapse(unique(data$latitude),' ; '),         '\n',
		   '\tc. Site(s) history ', '\n\t\t',               pasteAndCollapse(unique(data$growingCondition),' ; '), '\n',
		   '\t2. Experimental or sampling design \n',
		   '\ta. Design characteristics ', '\n\t\t',        getMetadataDesign(unique(data$dataset)),               '\n',
		   '\tb. Data collection period, frequency: \n',
		   '\t3. Research methods \n',
		   '\ta. Field Laboratory ', '\n\t\t',              getMetadataMethods(unique(data$dataset)),              '\n',
		   '\t4. Project personnel: ',                      getPersonell(unique(data$dataset)),                    '\n')	
}
