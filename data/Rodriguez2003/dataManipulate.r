raw[["Bark_Stemwood"]]                    <-  raw[["Bark"]] + raw[["Stemwood"]]
raw[["Crown_class"]][raw[["Crown_class"]]==1]  <-  "intermediate"
raw[["Crown_class"]][raw[["Crown_class"]]==1]  <-  "codominant"
raw[["Crown_class"]][raw[["Crown_class"]]==1]  <-  "dominant"
raw$grouping                         <-  makeGroups(raw, c("Treatment", "Crown_class"))

#calculate average sla
raw$sla <-(raw[["SLA_Lower_third"]]+raw[["SLA_Middle_Third"]]+raw[["SLA_Upper_third"]])/3
