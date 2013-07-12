manipulate <- function(raw) {
  
  # Fix grouping; easier to do here
  i <- which(names(raw) == "site type (1 =myrtillus, 2= Calluna type)")
  names(raw)[i] <- "Site type"
  raw[["Site type"]][raw[["Site type"]] == 1] <- "Myrtillus"
  raw[["Site type"]][raw[["Site type"]] == 2] <- "Calluna"
  raw$grouping <- makeGroups(raw, c("Site type","site code"))
  
  # height of crown base
  raw$hcb <- raw[["tree height CM"]] - raw[["crown length cm"]]
  
  # total sapwood mass
  raw$m.ss <- raw[["branch (sapwood)"]] + raw[["stem sapwood mass"]]
  
  # total heartwood mass
  raw$m.sh <- raw[["branch (heartwood)"]] + raw[["stem heartwood mass"]]
  
  # coarse root mass (including stump, since stump won't be part of the stem)
  raw$m.rc <- apply(raw[c("stump",
                          "roots (>20 cm)",
                          "scoarce roots (0,5-20 cm)",
                          "tap root")],1,sum,na.rm=TRUE)
  
  raw
}

