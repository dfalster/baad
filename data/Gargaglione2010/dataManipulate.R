manipulate <- function(raw) {
  raw$stem_mass         <-  raw[["total sapwood"]] + raw[["Total bark mass"]] + raw[["total heartwood"]]
  raw$branch_mass       <-  raw[["branches sapwood mass"]] + raw[["branches bark mass"]] + raw[["branches heartwood mass"]]
  raw$coarse_root_mass  <-  raw[["medium roots mass"]] + raw[["coarse roots mass"]]
  
  raw[["total N sapwood"]]    <-  (raw[["total N sapwood"]]/1000)/raw[["total sapwood"]]
  raw[["Total N bark"]]       <-  (raw[["Total N bark"]]/1000)/raw[["Total bark mass"]]
  raw[["total N heartwood"]]  <-  (raw[["total N heartwood"]]/1000)/raw[["total heartwood"]]
  raw[["N fine roots"]]       <-  (raw[["N fine roots"]]/1000)/raw[["fine roots mass"]]
  raw$NcoarseRoots            <-  ((raw[["N medium roots"]] + raw[["N coarse roots"]])/1000)/raw$coarse_root_mass
  raw
}

