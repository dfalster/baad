manipulate <- function(raw) {


  raw$branch_mass <-  raw[["branches sapwood mass"]] + raw[["branches bark mass"]] +
    raw[["branches heartwood mass"]] + raw[["small branches mass"]]

  raw$stem_mass <-  raw[["bole mass"]] + raw[["bark bole mass"]] + raw[["branch_mass"]]

  # Many rows in the dataset contain root data estimated from 'aerial components'.
  # Set these to NA.
  j <- raw$RootsEstimated == "y"
  raw[["N fine roots"]][j] <- NA
  raw[["N medium roots"]][j] <- NA
  raw[["N coarse roots"]][j] <- NA
  raw[["total N underground"]][j] <- NA
  raw[["fine roots mass"]][j] <- NA
  raw[["medium roots mass"]][j] <- NA
  raw[["coarse roots mass"]][j] <- NA
  raw[["total underground mass"]][j] <- NA
  raw[["total mass/tree"]][j] <- NA

  raw$coarse_root_mass  <-  raw[["medium roots mass"]] + raw[["coarse roots mass"]]

  # zero value in total sapwood, set to NA
  nm <- "total sapwood"
  raw[[nm]][raw[[nm]] == 0] <- NA
  
  raw[["total N sapwood"]]    <-  (raw[["total N sapwood"]]/1000)/raw[["total sapwood"]]
  raw[["Total N bark"]]       <-  (raw[["Total N bark"]]/1000)/raw[["Total bark mass"]]
  raw[["total N heartwood"]]  <-  (raw[["N heartwood"]]/1000)/raw[["total heartwood"]]
  raw[["N fine roots"]]       <-  (raw[["N fine roots"]]/1000)/raw[["fine roots mass"]]
  raw$NcoarseRoots            <-  ((raw[["N medium roots"]] + raw[["N coarse roots"]])/1000)/raw$coarse_root_mass

  # Dividing by zero gives Inf.
  raw[["total N heartwood"]][!is.finite(raw[["total N heartwood"]])] <- NA
  raw[["total N sapwood"]][!is.finite(raw[["total N sapwood"]])] <- NA
  raw[["Total N bark"]][!is.finite(raw[["Total N bark"]])] <- NA
  
  # zero d_bh is NA (note: zero dbh is possible when h.t < 1.4 or 1.3).
  d0 <- raw[["DBH (cm)"]] == 0
  raw[["DBH (cm)"]][d0] <- NA

  # grouping
  raw$grouping <- makeGroups(raw, "Site")

  # Fix zeroes.
  raw[["Total bark mass"]][raw[["Total bark mass"]] == 0] <- NA
  raw$stem_mass[raw$stem_mass == 0] <- NA
  raw$branch_mass[raw$branch_mass == 0] <- NA


  raw
}

