raw[["Leaf area"]]  <-  raw[[""]]
raw[["stem"]]       <-  raw[["stem"]]+raw[["branch"]]
raw[["m.rf"]]       <-  raw[["5-Oct"]] + raw[["Oct-15"]]
raw[["m.rc"]]       <-  raw[["15 - 20"]] + raw[["20  + stump"]]
raw$grouping   <-  paste("Harvested on ", raw[["Harvested"]], "; Plot = ", raw[["plot"]], "; Treatment = ", raw[["treatment"]], "; seedling = ", raw[["seedling"]], sep="")


