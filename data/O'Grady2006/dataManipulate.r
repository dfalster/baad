manipulate <- function(raw) {
  
  raw[["stem"]]       <-  raw[["stem"]]+raw[["branch"]]
  raw[["m.rf"]]       <-  raw[["5-Oct"]] + raw[["Oct-15"]]
  raw[["m.rc"]]       <-  raw[["15 - 20"]] + raw[["20  + stump"]]
  raw$grouping        <-  makeGroups(raw, c("Harvested","plot"))
  
  #Exclude data from zulu plot, these seem to be in different units. Send query to author
  raw  <-  raw[raw[["plot"]] != "zulu",]
  raw  <-  raw[!(raw[["plot"]] == 1 & raw[["seedling"]] ==16),]
  raw
}

