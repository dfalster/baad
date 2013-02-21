raw$a.babh <-raw$a.st - raw$a.st.1
names(raw)[names(raw)=="group"]  <-  "grouping"
raw$species=raw$species
raw$grouping=paste(raw$Variable, raw$contributor, raw$Nutrition, sep="; ")