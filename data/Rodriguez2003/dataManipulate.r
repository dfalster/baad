raw$Bark_Stemwood  <-raw$Bark + raw$Stemwood
raw$Crown_class[raw$Crown_class==1]  <-  "intermediate"
raw$Crown_class[raw$Crown_class==1]  <-  "codominant"
raw$Crown_class[raw$Crown_class==1]  <-  "dominant"
raw$grouping=paste("Treatment", raw$Treatment, raw$Crown_class, sep="; ")
