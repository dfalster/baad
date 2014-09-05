manipulate <- function(raw) {

  raw[["stem"]]       <-  raw[["stem"]]+raw[["branch"]]
  raw[["m.rf"]]       <-  raw[["5-Oct"]] + raw[["Oct-15"]]
  raw[["m.rc"]]       <-  raw[["15 - 20"]] + raw[["20  + stump"]]
  raw$grouping        <-  makeGroups(raw, c("Harvested","plot"))

  
  # A problem with leaf areas; first 36 need to be multiplied by 10
  # to get reasonable SLA values (RAD).
  raw$X[1:36] <- raw$X[1:36] * 10
  
  #Exclude data from zulu plot, these seem to be in different units
  raw  <-  raw[raw[["plot"]] != "zulu",]
  raw  <-  raw[!(raw[["plot"]] == 1 & raw[["seedling"]] ==16),]
  
}

