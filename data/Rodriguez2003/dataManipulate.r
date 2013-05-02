manipulate <- function(raw) {
  raw[["Bark_Stemwood"]]                    <-  raw[["Bark"]] + raw[["Stemwood"]]
  raw[["Crown_class"]][raw[["Crown_class"]]==1]  <-  "intermediate"
  raw[["Crown_class"]][raw[["Crown_class"]]==1]  <-  "codominant"
  raw[["Crown_class"]][raw[["Crown_class"]]==1]  <-  "dominant"
  raw$grouping                         <-  makeGroups(raw, c("Treatment", "Crown_class"))
  raw
}

