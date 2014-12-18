## Author information is handled as a proper maker target:
author_details <- function(first_authors, baad) {
  data_authors <- baad$contact
  data_authors <- data_authors[order(last_name(data_authors$name),
                                     data_authors$name),]
  data_authors$email[data_authors$email == ""] <- NA

  cols <- c("name", "email", "address")
  all_authors <- rbind(first_authors[cols], data_authors[,cols])
  all_authors <- all_authors[!duplicated(all_authors$name),]

  address <- unique(all_authors$address)
  address_table <- data.frame(code=seq_along(address), address=address)

  all_authors$address_code <- match(all_authors$address, address)

  list(authors=all_authors,
       address_table=address_table)
}

last_name <- function(author) {
  sapply(author, function(x)
         last(strsplit(x, ' ', useBytes=TRUE)[[1]]))
}

save_author_details <- function(d, filename) {
  write.csv(d$authors[c("name", "email", "address")], filename,
            row.names=FALSE)
}

## Below here still needs work

get_metadata_methods  <-  function(metadata) {
  if (nrow(metadata) > 0) {
    metadata <- metadata[!is.na(metadata$Description) &
                         !(tolower(metadata$Topic) %in% c('sampling strategy', 'age', 'growth environment', 'acknowledgements')),]
    paste0(metadata$Topic, ': ', metadata$Description, collapse='\n\t- ')
  }
}

get_metadata_design  <-  function(metadata) {
  metadata$Description[metadata$Topic == 'Sampling strategy']
}

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

study_details <- function(data, baad) {
  template <-
    c('## {{study_name}}',
      'Data from: {{citation}}\n',
      '1. Site Description',
      '\t- Site(s) type(s): {{site_type}}',
      '\t- Geography',
      '\t\t- latitude, longitude: {{latlon}}',
      '\t- Site(s) history: plant grown in {{site_history}}',
      '2. Experimental or sampling design',
      '\t- Design characteristics: {{design}}',
      '\t- Variables included: {{vars}}',
      '\t- Species sampled: *{{species}}*',
      '3. Research methods',
      '\t- {{lab}}',
      '4. Study contacts: {{personell}}'
      )

  template <- paste(template, collapse="\n")

  study_name <- data$studyName[[1]]

  personell <- baad$contacts$name[baad$contacts$studyName == study_name]
  personell <- paste0(personell, collapse=", ")

  metadata <- baad$metadata[baad$metadata$studyName == study_name,]
  metadata <- metadata[names(metadata) != study_name]

  site_type <- classify_veg_type(data$vegetation)
  site_history <- classify_site_history(data$growingCondition)
  metadata_methods <- get_metadata_methods(metadata)
  metadata_design <- get_metadata_design(metadata)

  ## Identify data columns that are not empty:
  common <- c("studyName", "species", "speciesMatched", "location",
              "latitude", "longitude", "vegetation", "map", "mat",
              "family", "pft", "growingCondition", "grouping")
  test <- setdiff(names(data), common)
  vars <- names(which(!apply(is.na(data[test]), 2, all)))

  dat <- list(
    study_name   = study_name,
    site_type    = site_type,
    latlon       = get_lat_long(data),
    site_history = site_history,
    design       = metadata_design,
    lab          = metadata_methods,
    personell    = personell,
    citation     = get_citation_ms(study_name, baad),
    vars         = paste0(vars, collapse=", "),
    species      = paste0(sort(unique(data$species)), collapse=", "))

  whisker.render(template, dat)
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

get_acknowledgements <- function(baad) {
  ack <- baad$metadata[baad$metadata$Topic == "Acknowledgements",]
  paste(sprintf("**%s:** %s", ack$studyName, ack$Description),
        collapse="; ")
}

## This is a temporary helper until first class rendering is done:
render_ms <- function(filename_md) {
  rmarkdown::render(filename_md, "html_document", quiet=TRUE)
}
