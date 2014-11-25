extract_study <- function(baad, study_name) {
  for (var in c("data", "contacts", "references")) {
    baad[[var]] <- baad[[var]][baad[[var]]$studyName == study_name, ]
  }
  baad[["bibtex"]] <- baad[["bibtex"]][[study_name]]
  baad
}

bib_element <- function(bib, name) {
  unclass(bib)[[1]][[name]]
}

md_link <- function(text, link) {
  sprintf("[%s](%s)", text, link)
}
md_link_doi <- function(doi) {
  md_link(doi, paste0("http://doi.org/", doi))
}

prep_map_info <- function(data, study_name=NA) {
  cols <- c("latitude", "longitude", "location")
  is_unique <- !duplicated(data[c("latitude", "longitude", "location")])
  dsub <- data[is_unique, cols]

  i <- !is.na(dsub$latitude) | !is.na(dsub$longitude)
  if (any(i)) {
    dsub$country <- NA_character_
    dsub$country[i] <- map.where(x=as.numeric(dsub$longitude[i]),
                                 y=as.numeric(dsub$latitude[i]))
  }

  dsub
}

## TODO: Can someone look into this and see if this is still useful?
## TODO: Why is "NA" a possibility?  I thought that NA strings would
## have dealt with that?
## TODO: 
report_missing_info <- function(data) {
  j <- (!is.na(data$latitude) & !is.na(data$longitude) &
        data$location != "NA" | is.na(data$location))
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
    return(cbind(lon=sj$lon[k], lat=sj$lat[k]))
  }
  # country Info
  k <- !is.na(sj$location) & is.na(sj$country)
  if (any(k)) {
    cat("Please notice that there is no country information for the following location(s):")
    return(cbind(sj$location[k]))
    cat("The most likely reason is either a missing or wrong coordinate, please revise")
  }
}

## TODO: This is a target for simplification later on.
## TODO: 10 is apprently special here
## TODO: lots of 1:10, 10:1 constructs that are needlessly confusing,
## especially `c(10:1)[1:nrow(subC)]`
drawCountryPlot <- function(data) {
  mapCountries <- unique(data$country)
  mapCountries <- mapCountries[!is.na(mapCountries)]
  countriesLen <- length(mapCountries)
  ppoint <- rep(c(21, 22, 23, 24, 25), 2)
  cpoint <- c("yellow", "blue", "darkgreen", "red", "grey", "black",
              "yellow", "blue", "darkgreen", "red")

  # make map for each country
  for (g in mapCountries) {
    zeta <- data$country == g
    subC <- data[zeta, ]

    if (nrow(subC) <= 10) {
      par(mfrow=c(1, 2), mar=c(4, 4, 5, 1))
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
        points(subD$longitude[1], subD$latitude[1],
               pch=subD$ppoint[1], col="black",
               bg=subD$cpoint[1], cex=0.8)
      }

      par(mar=c(2, 0, 2, 0))
      plot(0, 0, type="n", axes=FALSE, xlab="", ylab="",
           xlim=c(0, 20), ylim=c(-2, 12))
      for (i in c(10:1)[1:nrow(subC)]) {
        points(0, i, pch=subC$ppoint[which(c(10:1) == i)], col="black",
               bg=subC$cpoint[which(c(10:1) == i)])
        text(0.3, i, subC$location[which(c(10:1) == i)], pos=4, xpd=TRUE,
             cex=0.8)
      }
    } else {
      subC$org <- as.integer(cut(1:nrow(subC), ceiling(nrow(subC)/10)))
      for (f in unique(subC$org)) {
        subK <- subC[subC$org == f, ]

        par(mfrow=c(1, 2), mar=c(4, 4, 5, 1))
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
          points(subD$longitude[1], subD$latitude[1],
                 pch=subD$ppoint[1], col="black", bg=subD$cpoint[1],
                 cex=0.8)
        }

        par(mar=c(2, 0, 2, 0))
        plot(0, 0, type="n", axes=FALSE, xlab="", ylab="",
             xlim=c(0, 20), ylim=c(-2, 12))
        for (i in c(10:1)[1:nrow(subK)]) {
          points(0, i, pch=subK$ppoint[which(c(10:1) == i)], col="black",
                 bg=subK$cpoint[which(c(10:1) == i)])
          text(0.3, i, subK$location[which(c(10:1) == i)], pos=4, xpd=TRUE,
               cex=0.8)
        }
      }
    }
  }
}

location_level_info <- function(data) {
  vars <- c("location", "longitude", "latitude", "vegetation")
  loc <- data[!duplicated(data[, vars]), vars]
  ## TODO: "NA" should never happen here?
  loc[is.na(loc) | loc == "" | loc == "NA"] <- "missing"
  rownames(loc) <- NULL
  loc$vegetation <- classify_veg_type(loc$vegetation)
  names(loc) <- capitalize(names(loc))
  loc
}

stand_level_info <- function(data) {
  vars <- c("location", "grouping", "growingCondition")
  sta <- data[!duplicated(data[, vars]), vars]
  ## Only retain the grouping column if it is nonempty:
  if (all(is.na(sta$grouping))) {
    sta <- sta[names(sta) != "grouping"]
  }
  ## TODO: "NA" should never happen?
  sta[is.na(sta) | sta == "" | sta == "NA"] <- "missing"
  rownames(sta) <- NULL
  sta$growingCondition <- classify_site_history(sta$growingCondition)
  names(sta) <- capitalize(names(sta))
  sta
}

species_level_info <- function(data) {
  spec <- data.frame(species=unique(data$species), stringsAsFactors=FALSE)
  for (z in c("family", "pft")) {
    x <- data[[z]][match(spec$species, data$species)]
    x[x == "" | is.na(x)] <- "missing"
    spec[[z]] <- x
  }
  spec[spec$species == "" | is.na(spec$species)] <- "missing"
  rownames(spec) <- NULL
  spec$pft <- classify_pft(spec$pft)
  names(spec) <- capitalize(names(spec))
  spec
}

######################################################################

report_variable_plots <- function(data_study, data, dictionary) {
  labels <- sprintf("%s (%s)", dictionary$label, dictionary$units)
  names(labels) <- dictionary$variable

  ## determine variables to plot
  var_present <- colSums(!is.na(data_study$data[dictionary$variable])) > 0
  plot_vars <- dictionary$variable[dictionary$group == "tree" &
                                   dictionary$type == "numeric" &
                                   var_present]

  ## set up a vector of colours, each species with different color
  species <- as.factor(data_study$data$species)
  pal <- nice_colours(nlevels(species))
  cols <- pal[as.integer(species)]

  par(mfrow = c(2, 2))
  for (i in seq_along(plot_vars)) {
    v1 <- plot_vars[[i]]
    for (v2 in plot_vars[seq_along(plot_vars) > i]) {
      report_variable_plot1(data_study$data[c(v1, v2)],
                            data[c(v1, v2)], studycol=cols,
                            xlab=labels[[v1]], ylab=labels[[v2]])
    }
  }

  ## In last plot, add a species legend
  if (nlevels(species) > 1 && nlevels(species) < 20) {
    plot(1, type="n", ann=FALSE, axes=FALSE)
    legend("topleft", levels(species), pch=19, col=pal, cex=0.8, pt.cex=1)
  }
}

report_variable_plot1 <- function(data_study, data,
                                  maincol=make_transparent("grey", 0.5),
                                  studycol="red", pch=19, ...) {
  ## We get problems with values <= 0 on log plots.  Drop these.
  nonnegative <- function(d) {
    ok <- rowSums(!is.na(d) & d > 0) == ncol(d)
    ret <- d[ok,]
    attr(ret, "ok") <- ok
    ret
  }
  studycol <- rep(studycol, length.out=nrow(data_study))
  data_study <- nonnegative(data_study)
  studycol <- studycol[attr(data_study, "ok")]

  plot(nonnegative(data), col=maincol,
       log="xy", xaxt="n", yaxt="n", pch=pch, ...)
  points(data_study, col=studycol, pch=pch)
  axis_log10(1)
  axis_log10(2)
}

## returns up to 80 nice colours, generated using
## http://tools.medialab.sciences-po.fr/iwanthue/
nice_colours <- function(n=80) {
  cols <- c(
    "#75954F", "#D455E9", "#E34423", "#4CAAE1", "#451431", "#5DE737", "#DC9B94",
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
  cols[seq_len(n)]
}

is_wholenumber <- function(x, tol=.Machine$double.eps^0.5) {
  abs(x - round(x)) < tol
}

axis_log10 <- function(side=1, horiz=FALSE, labels=TRUE,
                       wholenumbers=TRUE, labelends=TRUE, las=1) {
  fg <- par("fg")
  if (side == 1 | side == 3) {
    r <- par("usr")[1:2]  #upper and lower limits of x-axis
  } else {
    r <- par("usr")[3:4]  #upper and lower limits of y-axis
  }

  at <- pretty(r)
  if (!labelends) {
    at <- at[at > r[1] & at < r[2]]
  }
  if (wholenumbers) {
    at <- at[is_wholenumber(at)]
  }

  if (labels) {
    lab <- do.call(expression, lapply(at, function(i) bquote(10^.(i))))
    axis(side, at=10^at, lab, col=if (horiz) fg else NA,
         col.ticks=fg, las=las)
  } else {
    axis(side, at=10^at, FALSE, col=if (horiz) fg else NA,
         col.ticks=fg, las=las)
  }
}
