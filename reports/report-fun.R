library(knitr, quietly = TRUE)
library(maps, quietly = TRUE)
library(mapdata, quietly = TRUE)
suppressPackageStartupMessages(library(gdata))

printAllStudyReports <- function(data = readRDS("../output/baad.rds"),
                                 studynames = unique(data$data$studyName),
    progressbar = TRUE, ...) {
    message("Generating ", length(studynames), " markdown reports.")
    if (progressbar) {
        wp <- txtProgressBar(min = 0, max = length(studynames), initial = 0, width = 50,
            style = 3)
    }

    output <- list()
    for (i in seq_along(studynames)) {
        output[[i]] <- printStudyReport(data, studynames[i], ...)
        if (progressbar)
            setTxtProgressBar(wp, i)
    }

    if (progressbar)
        close(wp)
}

# creates html reports using knitr
printStudyReport <- function(alldata, study, RmdFile = "report.Rmd", path = "output/report-by-study",
    name = study, delete = TRUE, reprocess = FALSE) {

    knitThis(RmdFile = RmdFile, path = path, name = name, delete = TRUE, reprocess = reprocess,
        predefined = list(.study = study, alldata = alldata, .dat = extractStudy(alldata,
            study)))
}

# creates html reports using knitr, copies output file to desired location and
# renames as required
knitThis <- function(RmdFile = "reportmd.Rmd", path = "output/report-per-study",
    name = "study", delete = TRUE, reprocess = TRUE, ..., predefined = list(...)) {

    outputfile <- paste0(path, "/", name, ".html")

    if (reprocess || !file.exists(outputfile)) {

        # create new environment with predfined variables
        e <- new.env()
        if (length(predefined) > 0) {
            # avoid issues when variables unnamed
            if (is.null(names(predefined)) || any(names(predefined) == ""))
                stop("All extra variables must be named")

            for (v in names(predefined)) assign(v, predefined[[v]], e)
        }

        # knit
        suppressMessages(knit2html(RmdFile, quiet = TRUE, envir = e))

        # copy html file to output dir
        if (!file.exists(path))
            dir.create(path, recursive = TRUE)

        # extract filename from RmdFile
        filebits <- strsplit(RmdFile, "/")[[1]]
        filename <- filebits[length(filebits)]

        # copy html file to output dir, rename
        file.copy(sub("Rmd", "html", filename), outputfile, overwrite = TRUE)

        # delete support files
        if (delete) {
            unlink(sub("Rmd", "html", filename))
            unlink(sub("Rmd", "md", filename))
            unlink("figure", recursive = TRUE)
        }
    }
    outputfile
}

extractStudy <- function(alldata, study) {
    for (var in c("data", "contacts", "references"))
        alldata[[var]] <- alldata[[var]][alldata[[var]]$studyName ==study, ]

    alldata[["bib"]] <- alldata[["bib"]][[study]]

    alldata
}

makePlotPanel <- function(data_all, data_study, dir = "report-per-study") {

    dict <- data_all$dictionary

    labels <- as.list(paste0(dict$label, " (", dict$Units, ")"))
    names(labels) <- dict$Variable

    # determine variables to plot
    plot.vars <- dict$Variable[dict$Group == "tree" & dict$Type == "numeric" & colSums(!is.na(data_study$data[,
        dict$Variable])) > 0]

    # set up a vector of colors, each species with different color
    species <- as.numeric(as.factor(data_study$data$species))
    colorvec <- niceColors()[match(species, unique(species))]

    par(mfrow = c(2, 2))
    count <- 0

    for (v1 in plot.vars) for (v2 in plot.vars) {
        if (match(v2,plot.vars) > match(v1,plot.vars)) {
            suppressWarnings(makePlot(data_all$data, data_study$data, studycol = colorvec,
                xvar = v1, yvar = v2, xlab = labels[[v1]], ylab = labels[[v2]]))
            count <- count + 1
            if (count == 4) {
                par(mfrow = c(2, 2))
                count <- 0
            }
        }
    }
  
    # In last plot, add a species legend
    nspec <- length(unique(data_study$data$species))
    if(nspec > 1 & nspec < 20){
      plot(1, type='n', ann=FALSE, axes=FALSE)
      legend("topleft", levels(as.factor(data_study$data$species)), pch=19, 
             col=niceColors(), cex=0.8, pt.cex=1)
    }
    
}

makePlot <- function(data, subset, xvar, yvar, xlab, ylab, main = "", maincol = make.transparent("grey",
    0.5), studycol = "red", pch = 19) {

  
    plot(data[, xvar], data[, yvar], log = "xy", col = maincol, xlab = xlab, ylab = ylab,
        main = main, las = 1, yaxt = "n", xaxt = "n", pch = pch)

    # add nice log axes
    axis.log10(1)
    axis.log10(2)

    # add data for select study, highlighted in red
    points(subset[, xvar], subset[, yvar], col = studycol, pch = pch)
    
}

prepMapInfo <- function(data, study = NA) {

    if (!is.na(study))
        data <- data[data$studyName %in% study, ]

    # Remove duplicate locations
    keep <- c("studyName", "latitude", "longitude", "location")

    data <- data[!duplicated(paste0(data$studyName, ";", data$latitude, ";", data$longitude,
        ";", data$location)), keep]

    i <- !is.na(data$latitude) | !is.na(data$longitude)
    if (any(i)) {
        data$country <- ""
        data$country[i] <- map.where(x = as.numeric(data$longitude[i]), y = as.numeric(data$latitude[i]))
    }

    data
}

drawWorldPlot <- function(data, horlines = TRUE, sizebyn = FALSE, add = FALSE, pchcol = "red",
    legend = TRUE) {

    if (!add) {
        map("world", col = "grey80", bg = "white", lwd = 0.5, fill = TRUE, resolution = 0,
            wrap = TRUE, border = "grey80")
        map("world", col = "black", boundary = TRUE, lwd = 0.2, interior = FALSE,
            fill = FALSE, add = TRUE, resolution = 0, wrap = TRUE)
    }

    if (horlines) {
        lines(c(-180, 180), c(-100, -100), lty = "dashed", xpd = TRUE, lwd = 2)
        lines(c(-180, 180), c(100, 100), lty = "dashed", xpd = TRUE, lwd = 2)
    }

    # Remove all duplicates (increases speed and minimizes file size)
    latlon <- with(data, paste(latitude, longitude))
    lat <- data$latitude[!duplicated(latlon)]
    lon <- data$longitude[!duplicated(latlon)]

    j <- !is.na(lat) & !is.na(lon)
    # Location only sometimes missing - but lat/lon can still be in dataset anyway.
    # & data$loc != 'NA' | is.na(data$loc)

    if (!any(j)) {
        polygon(c(-100, 95, 95, -100), c(-10, -10, 15, 15), col = rgb(0, 0, 0, 240,
            maxColorValue = 255))
        text(-100, 0, expression(paste(bold("Missing coordinate/location"))), col = "red",
            xpd = TRUE, pos = 4, cex = 0.8)
    } else {

        if (!sizebyn) {
            points(lon, lat, pch = 19, col = pchcol, bg = pchcol, cex = 0.6)
        } else {
            n <- table(latlon)
            # sort so that small circles will be plotted on top of large ones.
            ii <- order(n, decreasing = TRUE)

            symbols(lon[ii], lat[ii], circles = log10(n[ii]), inches = 0.1, fg = "black",
                bg = pchcol, add = TRUE)

            if (legend) {
                ns <- c(10, 100, 1000)
                X <- rep(-170, 3)
                Y <- seq(-30, -10, by = 10)
                rect(xleft = -200, xright = -120, ybottom = -50, ytop = 10, col = "white",
                  border = NA)
                symbols(x = X, y = Y, circles = log10(ns), inches = 0.1, fg = "black",
                  bg = pchcol, add = TRUE)
                text(x = X + 5, y = Y, labels = as.character(ns), pos = 4)
                text(x = X + 5, y = Y[3] + 10, labels = expression(italic(n)), pos = 4)
            }

        }

    }

}

repMissingInfo <- function(data) {
    j <- !is.na(data$latitude) & !is.na(data$longitude) & data$location != "NA" | is.na(data$location)
    sj <- data[!j, ]

    # location Info
    k <- !is.na(sj$location) & is.na(sj$longitude)
    if (length(k[k == TRUE]) > 0) {
        cat("Please notice that there are no coordinates for the following location(s):")
        return(cbind(sj$location[k]))
    }
    # coordinate Info
    k <- !is.na(sj$longitude) & is.na(sj$location) | sj$location == "NA"
    if (any(k)) {
        cat("Please notice that there is no location information for the following coordinate(s):")
        return(cbind(lon = sj$lon[k], lat = sj$lat[k]))
    }
    # country Info
    k <- !is.na(sj$location) & is.na(sj$country)
    if (any(k)) {
        cat("Please notice that there is no country information for the following location(s):")
        return(cbind(sj$location[k]))
        cat("The most likely reason is either a missing or wrong coordinate, please revise")
    }
}

drawCountryPlot <- function(data) {

    mapCountries <- unique(data$country)
    mapCountries <- mapCountries[!is.na(mapCountries)]
    countriesLen <- length(mapCountries)
    ppoint <- rep(c(21, 22, 23, 24, 25), 2)
    cpoint <- c("yellow", "blue", "darkgreen", "red", "grey", "black", "yellow",
        "blue", "darkgreen", "red")

    # make map for each country
    for (g in mapCountries) {
        zeta <- data$country == g
        subC <- data[zeta, ]

        if (nrow(subC) <= 10) {

            par(mfrow = c(1, 2), mar = c(4, 4, 5, 1))
            if (g == "USA") {
                map("usa")
            } else {
                map("worldHires", g)
            }
            title(g)
            subC$group <- as.numeric(as.factor(paste0(subC$longitude, subC$latitude)))
            subC$cpoint <- cpoint[match(subC$group, 1:10)]
            subC$ppoint <- ppoint[match(subC$group, 1:10)]
            for (d in unique(subC$group)) {
                subD <- subC[subC$group == d, ]
                points(subD$longitude[1], subD$latitude[1], pch = subD$ppoint[1], col = "black",
                  bg = subD$cpoint[1], cex = 0.8)
            }

            par(mar = c(2, 0, 2, 0))
            plot(0, 0, type = "n", axes = FALSE, xlab = "", ylab = "", xlim = c(0,
                20), ylim = c(-2, 12))
            for (i in c(10:1)[1:nrow(subC)]) {
                points(0, i, pch = subC$ppoint[which(c(10:1) == i)], col = "black",
                  bg = subC$cpoint[which(c(10:1) == i)])
                text(0.3, i, subC$location[which(c(10:1) == i)], pos = 4, xpd = TRUE,
                  cex = 0.8)
            }

        } else {
            subC$org <- as.integer(cut(1:nrow(subC), ceiling(nrow(subC)/10)))
            for (f in unique(subC$org)) {
                subK <- subC[subC$org == f, ]

                par(mfrow = c(1, 2), mar = c(4, 4, 5, 1))
                if (g == "USA") {
                  map("usa")
                } else {
                  map("worldHires", g)
                }
                title(g)
                subK$group <- as.numeric(as.factor(paste0(subK$longitude, subK$latitude)))
                subK$cpoint <- cpoint[match(subK$group, 1:10)]
                subK$ppoint <- ppoint[match(subK$group, 1:10)]
                for (d in unique(subK$group)) {
                  subD <- subK[subK$group == d, ]
                  points(subD$longitude[1], subD$latitude[1], pch = subD$ppoint[1], col = "black",
                    bg = subD$cpoint[1], cex = 0.8)
                }

                par(mar = c(2, 0, 2, 0))
                plot(0, 0, type = "n", axes = FALSE, xlab = "", ylab = "", xlim = c(0,
                  20), ylim = c(-2, 12))
                for (i in c(10:1)[1:nrow(subK)]) {
                  points(0, i, pch = subK$ppoint[which(c(10:1) == i)], col = "black",
                    bg = subK$cpoint[which(c(10:1) == i)])
                  text(0.3, i, subK$location[which(c(10:1) == i)], pos = 4, xpd = TRUE,
                    cex = 0.8)
                }
            }
        }
    }
}

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) abs(x - round(x)) <
    tol

axis.log10 <- function(side = 1, horiz = FALSE, labels = TRUE, wholenumbers = T,
    labelEnds = T, las = 1) {
    fg <- par("fg")

    # get range on axis
    if (side == 1 | side == 3) {
        r <- par("usr")[1:2]  #upper and lower limits of x-axis
    } else {
        r <- par("usr")[3:4]  #upper and lower limits of y-axis
    }

    # make pertty intervals
    at <- pretty(r)
    # drop ends if desirbale
    if (!labelEnds)
        at <- at[at > r[1] & at < r[2]]
    # restrict to whole numbers if desriable
    if (wholenumbers)
        at <- at[is.wholenumber(at)]

    # make labels
    if (labels) {
        lab <- do.call(expression, lapply(at, function(i) bquote(10^.(i))))
        axis(side, at = 10^at, lab, col = if (horiz)
            fg else NA, col.ticks = fg, las = las)
    } else {
        axis(side, at = 10^at, FALSE, col = if (horiz)
            fg else NA, col.ticks = fg, las = las)
    }
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

# returns up to 80 nice colors, generated using
# http://tools.medialab.sciences-po.fr/iwanthue/
niceColors <- function(n = 80) {
    cols <- c("#75954F", "#D455E9", "#E34423", "#4CAAE1", "#451431", "#5DE737", "#DC9B94",
        "#DC3788", "#E0A732", "#67D4C1", "#5F75E2", "#1A3125", "#65E689", "#A8313C",
        "#8D6F96", "#5F3819", "#D8CFE4", "#BDE640", "#DAD799", "#D981DD", "#61AD34",
        "#B8784B", "#892870", "#445662", "#493670", "#3CA374", "#E56C7F", "#5F978F",
        "#BAE684", "#DB732A", "#7148A8", "#867927", "#918C68", "#98A730", "#DDA5D2",
        "#456C9C", "#2B5024", "#E4D742", "#D3CAB6", "#946661", "#9B66E3", "#AA3BA2",
        "#A98FE1", "#9AD3E8", "#5F8FE0", "#DF3565", "#D5AC81", "#6AE4AE", "#652326",
        "#575640", "#2D6659", "#26294A", "#DA66AB", "#E24849", "#4A58A3", "#9F3A59",
        "#71E764", "#CF7A99", "#3B7A24", "#AA9FA9", "#DD39C0", "#604458", "#C7C568",
        "#98A6DA", "#DDAB5F", "#96341B", "#AED9A8", "#55DBE7", "#57B15C", "#B9E0D5",
        "#638294", "#D16F5E", "#504E1A", "#342724", "#64916A", "#975EA8", "#9D641E",
        "#59A2BB", "#7A3660", "#64C32A")
    cols[1:n]
}

getExpression <- function(units) {
    switch(units, m2 = "m^2", mm = "mm", yr = "yr", m = "m", kg = "kg", kg.m2 = "kg m^-2",
        kg.m3 = "kg m^-3", kg.kg = "kg.kg")
}

bibGetElement <- function(bib, element = "doi") {
    unclass(bib[[1]])[[1]][[element]]
}

locLevelInfo <- function(data) {

  vars <- c("location", "longitude", "latitude", "vegetation")
  loc <- data[!duplicated(data[, vars]), vars]
  loc[is.na(loc) | loc == "" | loc == "NA"] <- "missing"
  loc
}

standLevelInfo <- function(data) {

    vars <- c("location", "grouping", "growingCondition")  #,'status')
    sta <- data[!duplicated(data[, vars]), vars]

    if (all(is.na(sta$grouping)))
        sta <- sta[, -which(names(sta) == "grouping")]

    sta[is.na(sta) | sta == "" | sta == "NA"] <- "missing"
  sta
}

spLevelInfo <- function(data) {
    spec <- data.frame(species = as.character(unique(data$species)), stringsAsFactors = FALSE)
    for (z in c("family", "pft")) {
        spec[[z]] <- as.character(data[[z]][match(spec$species, data$species)])
        i <- spec[[z]] == "" | is.na(spec[[z]])
        if (any(i)) {
            spec[[z]][i] <- "missing"
        }
    }
    j <- spec$species == "" | is.na(spec$species)
    if (any(j)) {
        spec$species[j] <- "missing"
    }
    spec
}

getMeta <- function(study) {
    read.csv(paste0("../data/", study, "/studyMetadata.csv"), h = TRUE, stringsAsFactors = FALSE)
}
