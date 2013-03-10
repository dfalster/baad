
raw[["stem"]]       <-  raw[["stem"]]+raw[["branch"]]
raw[["m.rf"]]       <-  raw[["5-Oct"]] + raw[["Oct-15"]]
raw[["m.rc"]]       <-  raw[["15 - 20"]] + raw[["20  + stump"]]
raw$grouping        <-  paste("Harvested on ", raw[["Harvested"]], "; Plot = ", raw[["plot"]], "; Treatment = ", raw[["treatment"]], "; seedling = ", raw[["seedling"]], sep="")

#Exclude data from zulu plot, these seem to be in different units. Send query to author
raw  <-  raw[raw[["plot"]] != "zulu",]
raw  <-  raw[!(raw[["plot"]] == 1 & raw[["seedling"]] ==16),]
