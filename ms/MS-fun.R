library(knitr, quietly = TRUE)
library(maps, quietly = TRUE)
library(bibtex, quietly = TRUE)
library(knitcitations, quietly = TRUE)
library(plyr, quietly = TRUE)

## Mimic dataMashR function here, but relative to *this* directory.
data.path <- function(root="..",...) {
  file.path(root, "data", ...)
}

#Paste and collapse
pasteC  <-  function(values, binder="\n") {
	paste0(unique(values), collapse=binder)
}

readStudyFile  <-  function(studyName, File, ...) {
	read.csv(data.path(studyName, File, ...), header = TRUE,
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
      	'\t\t- latitude, longitude: {{latlon}}',
		'\t- Site(s) history: plant grown in {{siteHistory}}',
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
           	          personell=pasteC(
           	          	readStudyFile(unique(data$studyName), "studyContact.csv")[,"name", drop=TRUE],", "),
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

authorDetails  <-  function(data, root="..") {
	firstAuthors   <-  read.csv(file.path(root, "config", "contact.csv"), header = TRUE,
        na.strings = c(NA,''), stringsAsFactors = FALSE, strip.white = TRUE)
	dataAuthors <- arrange(ldply(unique(data$studyName),function(x) readStudyFile(x, "studyContact.csv", root=root)), name)
	allAuthors <- rbind(firstAuthors,
		dataAuthors[order(getLastName(dataAuthors$name)),])
	allAuthors <- allAuthors[!duplicated(allAuthors$name),]

	authors <- allAuthors$name
	emails <- allAuthors$email
	addresses_unique_in_order <- allAuthors$address[!duplicated(allAuthors$address)]

	adressList <- match(allAuthors$address, addresses_unique_in_order)

	list(authors=authors	, emails=emails, address_code=adressList, address=data.frame(code=seq_len(length(addresses_unique_in_order)), address=addresses_unique_in_order))
}

capitalize <- function (string) {
    capped <- grep("^[^A-Z]*$", string, perl = TRUE)
    substr(string[capped], 1, 1) <- toupper(substr(string[capped],
        1, 1))
    string
}

## Make colours semitransparent:
make.transparent <- function(col, opacity = 0.5) {
    if (length(opacity) > 1 && any(is.na(opacity))) {
        n <- max(length(col), length(opacity))
        opacity <- rep(opacity, length.out = n)
        col <- rep(col, length.out = n)
        ok <- !is.na(opacity)
        ret <- rep(NA, length(col))
        ret[ok] <- Recall(col[ok], opacity[ok])
        ret
    } else {
        tmp <- col2rgb(col)/255
        rgb(tmp[1, ], tmp[2, ], tmp[3, ], alpha = opacity)
    }
}

drawWorldPlot  <-  function(data, sizebyn=FALSE, add=FALSE,
                            pchcol="red",
                            legend=TRUE){


  require(maps)
  if(!add){
    map('world',col="grey80",bg="white",lwd=0.5,fill=TRUE,resolution=0,wrap=TRUE, border="grey80", ylim=c(-80, 80), mar=rep(0,4))
    map('world',col="black",boundary=TRUE,lwd=0.2,interior=FALSE,fill=FALSE,add=TRUE,resolution=0,wrap=TRUE)
  }


  # Remove all duplicates (increases speed and minimizes file size)
  latlon <- with(data, paste(latitude, longitude))
  lat <- data$latitude[!duplicated(latlon)]
  lon <- data$longitude[!duplicated(latlon)]

  j  <-  !is.na(lat) & !is.na(lon)

  # Location only sometimes missing - but lat/lon can still be in dataset anyway.
  # & data$loc != "NA" | is.na(data$loc)

  if(!any(j)){
    polygon(c(-100,95,95,-100), c(-10,-10,15,15), col=rgb(0,0,0,240,maxColorValue=255))
    text(-100, 0, expression(paste(bold("Missing coordinate/location"))), col="red", xpd=TRUE, pos=4, cex=0.8)
  } else {

    if(!sizebyn){
      points(lon,lat, pch=19, col=make.transparent("blue",0.5), cex=1.6)
    } else {
      n <- table(latlon)
      symbols(lon,lat, circles=log10(n), inches=0.1, fg="black", bg=pchcol, add=TRUE)

      if(legend){
        ns <- c(10,100,1000)
        X <- rep(-170,3)
        Y <- seq(-30,-10,by=10)
        rect(xleft=-200, xright=-120, ybottom=-50, ytop=10, col="white", border=NA)
        symbols(x=X, y=Y, circles=log10(ns), inches=0.1,
                fg="black", bg=pchcol, add=TRUE)
        text(x=X+5, y=Y, labels=as.character(ns),pos=4)
        text(x=X+5, y=Y[3]+10, labels=expression(italic(n)), pos=4)
      }
    }
  }
}


summaryTable <- function(data, var.def, digits = 2){

	thesevars <- setdiff(var.def$variable[var.def$type=="numeric"], c("map","mat","lai"))

	N <- sapply(thesevars, function(x)length(data[[x]][!is.na(data[[x]])]))

	Nstud <- sapply(thesevars, function(x)length(unique(data[["studyName"]][!is.na(data[[x]])])))

	df <- rbind.fill(apply(data[,thesevars], 2, function(x)data.frame(Min=min(x, na.rm=TRUE),Max=max(x, na.rm=TRUE),Median=median(x, na.rm=TRUE))))
	dfr <- data.frame(Variable=thesevars, N=N, Studies=Nstud)

	dfr <- cbind(dfr,df)

	for(v in c("Min", "Max", "Median"))
		dfr[[v]] <- formatC(dfr[[v]], digits=digits, format="fg")

	dfr[["Units"]] <- var.def$unitsMD[match(thesevars, var.def$variable)]
	dfr[["Variable"]] <- var.def$variable[match(thesevars, var.def$variable)]
	dfr[["Label"]] <- capitalize(var.def$label[match(thesevars, var.def$variable)])

	dfr <- dfr[dfr$N > 0,c("Variable",  "Label", "Units", "N", "Studies","Min","Median","Max")]
	rownames(dfr) <- NULL

	dfr
}
