# functions that were used in manuscript and are still sued in reports

drawWorldPlot <- function(data, sizebyn=FALSE, add=FALSE,
                          pchcol="red", legend=TRUE) {
  if (!add){
    map('world',col="grey80",bg="white",lwd=0.5,fill=TRUE,resolution=0,wrap=TRUE, border="grey80", ylim=c(-80, 80), mar=rep(0,4))
    map('world',col="black",boundary=TRUE,lwd=0.2,interior=FALSE,fill=FALSE,add=TRUE,resolution=0,wrap=TRUE)
  }

  ## See reports-port
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
      points(lon,lat, pch=19, col=pchcol, cex=0.6)
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

classify <- function(code, table) {
  ret <- unname(table[unique(code)])
  ret[is.na(ret)] <- ""
  paste(ret, collapse=", ")
}

classify_veg_type <-function(code) {
  dat <- c(Sav = "Savannah",
           TropRF = "Tropical rainforest",
           TempRF = "Temperate rainforest",
           TropSF = "Tropical seasonal forest",
           TempF = "Temperate forest",
           BorF = "Boreal forest",
           Wo = "Woodland",
           Gr = "Grassland",
           Sh = "Shrubland",
           De = "Desert")
  classify(code, dat)
}

classify_site_history <- function(code) {
  dat <- c(FW = "field wild",
           FE = "field experimental",
           GH = "glasshouse",
           PU = "plantation unmanaged",
           PM = "plantation managed",
           GC = "growth chamber",
           CG = "common garden")
  classify(code, dat)
}

classify_pft <- function(code) {
  dat <- c(EA = "evergreen angiosperm",
           DA = "deciduous angiosperm",
           EG = "evergreen gymnosperm",
           DG = "deciduous gymnosperm")
  classify(code, dat)
}

get_lat_long <- function(data) {
  uniquesites <- data[!duplicated(data[,c("longitude", "latitude")]),]
  paste(prettyNum(uniquesites$latitude),
        prettyNum(uniquesites$longitude), sep=", ", collapse="; ")
}

get_citation_ms <-  function(study_name, baad) {
  i <- match(study_name, baad$references$studyName)
  citation <- baad$references$citation[i]

  if (baad$references$doi[i] != "") {
    citation <- sprintf("%s DOI: %s.",
                        citation, md_link_doi(baad$references$doi[i]))
  } else if (baad$references$url[i] != "") {
    citation <- sprintf("%s %s.",
                        citation, md_link("LINK",baad$references$url[i]))
  }
  citation
}

variable_details <- function(var_def) {
  f <- function(x) {
    paste0("* ", x$variable,
           "\n\t- Type: ", x$type,
           "\n\t- Label: ", x$label,
           "\n\t- Description: ", x$description,
           "\n\t- Units: ", format_units(x$units)
           )
  }
  ret <- plyr::daply(var_def, 1, f)
  ret[var_def$variable]
}

format_units <- function(units){

  old <- c("/m2", "/m3", "m2", "m3", "/kg" )
  new <- c(" m<sup>-2</sup>", " m<sup>-3</sup>", "m<sup>2</sup>", "m<sup>3</sup>", " kg<sup>-1</sup>")
  for(i in seq_len(length(old)))
     units <- gsub(old[i], new[i], units, fixed=TRUE)
  units
}

summary_table <- function(data, var_def, digits=2) {
  thesevars <- setdiff(var_def$variable[var_def$type == "numeric"],
                       c("map", "mat", "lai"))

  N <- colSums(!is.na(data[thesevars]))
  thesevars <- thesevars[N > 0]
  N <- N[N > 0]

  Nstud <- sapply(data[thesevars], function(x)
                  length(unique(data$studyName[!is.na(x)])))

  df <- rbind.fill(apply(data[thesevars], 2, function(x)
                         data.frame(Min=min(x, na.rm=TRUE),
                                    Max=max(x, na.rm=TRUE),
                                    Median=median(x, na.rm=TRUE))))

  dfr <- data.frame(Variable=thesevars, N=N, Studies=Nstud)
  dfr <- cbind(dfr, df)

  for (v in c("Min", "Max", "Median")) {
    dfr[[v]] <- formatC(dfr[[v]], digits=digits, format="fg")
  }

  i <- match(thesevars, var_def$variable)
  dfr$Units    <- format_units(var_def$units[i])
  dfr$Variable <- var_def$variable[i]
  dfr$Label    <- capitalize(var_def$label[i])

  dfr <- dfr[c("Variable", "Label", "Units", "N", "Studies",
               "Min", "Median", "Max")]
  rownames(dfr) <- NULL

  dfr
}


## This is a temporary helper until first class rendering is done:
render_html <- function(filename_md) {
  rmarkdown::render(filename_md, "html_document", quiet=TRUE)
}

## This is a temporary helper until first class rendering is done:
render_doc <- function(filename_md) {
  rmarkdown::render(filename_md, "word_document", quiet=TRUE)
}
