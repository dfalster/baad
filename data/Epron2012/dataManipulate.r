raw[["a.babh"]] <-  raw[["a.st"]] - raw[["a.st1"]]
raw[["group"]]  <-  paste(raw[["Variable"]], raw[["contributor"]], raw[["Nutrition"]], sep="; ")
raw[["a.cs"]]  <-  pi*(raw[["a.cp"]]/100)^2

#Error correction - heights for plants age =0.5 at top of datasets in different units to rest of datasets (cm rather than m)
i <-1:8
raw[["h.t"]][i] <- raw[["h.t"]][i]/100
raw[["h.c"]][i] <- raw[["h.c"]][i]/100
