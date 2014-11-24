post_process <- function(data){
  ## Fill missing derived variables (e.g. m.so= m.st+m.lf, etc.)
  data <- fill_derived_variables(data)

  ## Add matched species name.
  data <- check_species_names(data)

  data
}

fill_derived_variables <- function(data) {
  to_numeric <- c("c.d", "m.rt", "a.cp", "d.cr")
  data[to_numeric] <- lapply(data[to_numeric], as.numeric)

  # Missing leaf area when leaf mass and LMA are OK.
  ii <- is.na(data$a.lf) & !is.na(data$m.lf) & !is.na(data$ma.ilf)
  data$a.lf[ii] <- data$m.lf[ii] / data$ma.ilf[ii]

  # Missing leaf mass when leaf area and LMA are OK.
  ii <- is.na(data$m.lf) & !is.na(data$a.lf) & !is.na(data$ma.ilf)
  data$m.lf[ii] <- data$a.lf[ii] * data$ma.ilf[ii]

  # Height to crown base if tree height and crown depth are OK.
  ii <- is.na(data$h.c) & !is.na(data$c.d) & !is.na(data$h.t)
  data$h.c[ii] <- data$h.t[ii] - data$c.d[ii]

  # Crown depth if tree height and height to crown base are OK
  ii <- is.na(data$c.d) & !is.na(data$h.t) & !is.na(data$h.c)
  data$c.d[ii] <- data$h.t[ii] - data$h.c[ii]

  # Stem area  / DBH at breast height or base.
  ii <- is.na(data$a.stbh) & !is.na(data$d.bh)
  data$a.stbh[ii] <- (pi/4) * data$d.bh[ii]^2

  ii <- is.na(data$a.stba) & !is.na(data$d.ba)
  data$a.stba[ii] <- (pi/4) * data$d.ba[ii]^2

  # Again, the other way around.
  ii <- !is.na(data$a.stbh) & is.na(data$d.bh)
  data$d.bh[ii] <- sqrt(data$a.stbh[ii] / (pi/4))

  ii <- !is.na(data$a.stba) & is.na(data$d.ba)
  data$d.ba[ii] <- sqrt(data$a.stba[ii] / (pi/4))

  # Stem mass
  ii <- is.na(data$m.st) & !is.na(data$m.ss) & !is.na(data$m.sh) &
    !is.na(data$m.sb)
  data$m.st[ii] <- data$m.ss[ii] + data$m.sh[ii] + data$m.sb[ii]

  # total aboveground mass.
  ii <- is.na(data$m.so) & !is.na(data$m.lf) & !is.na(data$m.st)
  data$m.so[ii] <- data$m.lf[ii] + data$m.st[ii]

  # total root mass
  ii <- is.na(data$m.rt) & !is.na(data$m.rf) & !is.na(data$m.rc)
  data$m.rt[ii] <- data$m.rf[ii] + data$m.rc[ii]

  # Total mass.
  ii <- is.na(data$m.to) & !is.na(data$m.rt) & !is.na(data$m.so)
  data$m.to[ii] <- data$m.rt[ii] + data$m.so[ii]

  # crown width
  ii <- is.na(data$d.cr) & !is.na(data$a.cp)
  data$d.cr[ii] <- sqrt(data$a.cp[ii] / (pi/4))

  # crown area
  ii <- !is.na(data$d.cr) & is.na(data$a.cp)
  data$a.cp[ii] <- (pi/4) * data$d.cr[ii]^2

  data
}

rebuild_species_cache <- function(species) {
  file.remove("config/taxon_updates.csv")
  invisible(update_species_cache(species, "config/taxon_updates.csv"))
}

check_species_names <- function(data) {
  sp_info <- update_species_cache(data$species, "config/taxon_updates.csv")

  i <- match(data$species, sp_info$species)
  species_matched  <- sp_info$species_matched[i]

  ## Missing values here should not happen:
  if (any(is.na(i))) {
    warning("Some species names were missing -- should not happen!")
    species_matched[is.na(i)] <- data$species[is.na(i)]
  }

  ## Arrange this into the final data frame next to the 'species'
  ## column:
  s <- seq_len(match("species", names(data)))
  cbind(data[s], speciesMatched=species_matched, data[-s],
        stringsAsFactors=FALSE)
}

update_species_cache <- function(species, cachefile) {
  species <- sort(unique(as.character(species)))
  if (file.exists(cachefile)) {
    cache <- read.csv(cachefile, stringsAsFactors=FALSE)
  } else {
    cache <- NULL
  }

  n_cached <- length(intersect(species, cache$species))
  species <- setdiff(species, cache$species)
  n_lookup <- length(species)


  if (n_lookup > 0L) {
    message(sprintf("Looking up %d species (%d cached)",
                    n_lookup, n_cached))
    ## ---- Taxonstand
    species1 <- lookup_taxonstand(species)

    sp_missing <- species[is.na(species1)]
    species2 <- lookup_taxize(sp_missing)

    info <- data.frame(species=species,
                       species_Taxonstand=species1,
                       species_taxize=NA_character_,
                       species_matched=NA_character_,
                       stringsAsFactors=FALSE, row.names=NULL)
    info$species_taxize[match(sp_missing, species)] <- species2

    ## Variable species_Fixed in cache is from Taxonstand, or taxize
    ## when Taxonstand returned NA.  When both Taxonstand and taxize
    ## don't have any suggestions, we go with NA.
    info$species_matched <- info$species_Taxonstand
    i <- is.na(info$species_matched)
    info$species_matched[i] <- info$species_taxize[i]
    i <- is.na(info$species_matched)
    info$species_matched[i] <- info$species[i]

    ## Standardise unknown species:
    unk <- grep("un(known|identified)", info$species, ignore.case=TRUE)
    info$species_matched[unk] <- "Unknown"

    ## Rewrite species that are genus only become Genus sp:
    i <- !grepl(" ", info$species_matched) & info$species_matched != "Unknown"
    info$species_matched[i] <- paste(info$species_matched[i], "sp.")

    ## Don't alter hybrid names
    hyb <- grep(" [*x] ", info$species)
    info$species_matched[hyb] <- info$species[hyb]

    ## Combine cache with new results, and write out:
    cache <- rbind(cache, info)
    write.csv(cache, cachefile, row.names=FALSE)
  }

  cache[c("species", "species_matched")]
}

lookup_taxonstand <- function(species) {
  ## Need to drop things in parentheses because they break
  ## taxonstand's use of regular expressions.  It's possible that
  ## running the substitutions
  ##   sub("\\(", "\\\\\\(", species)
  ##   sub("\\)", "\\\\\\)", species)
  ## will also work, but I've not tested this.
  species <- sub("\\s*\\(.+$", "", species)

  starttime <- proc.time()
  capture.output(tpl <- TPL(species, corr=TRUE), file=tempfile())
  endtime <- proc.time()
  message(sprintf("Taxonstand query completed in %2.1f minutes.",
                  (endtime - starttime)[[3]] / 60))

  ret <- structure(rep(NA_character_, length(species)), names=species)
  i <- tpl$Plant.Name.Index
  ret[i] <- paste(tpl$New.Genus[i], tpl$New.Species[i])
  ret
}

lookup_taxize <- function(species) {
  ## Use 'POST' rather than 'GET'
  ## https://github.com/ropensci/taxize/issues/262#issuecomment-39232271
  ## Probably fixed already in upstream taxize.
  starttime <- proc.time()
  txz <- gnr_resolve(species, stripauthority=TRUE, http='post')
  endtime <- proc.time()
  message(sprintf("Taxize query completed in %2.1f minutes.",
                  (endtime - starttime)[[3]] / 60))

  ret <- structure(rep(NA_character_, length(species)), names=species)
  dat <- split(txz$results, txz$results$submitted_name)
  i <- sapply(dat, function(x)
              x$score[[1]] > 0.9 && length(unique(x$matched_name2)) == 1L)
  ret[i] <- sapply(dat[i], function(x) x$matched_name2[[1]])
  ret
}
