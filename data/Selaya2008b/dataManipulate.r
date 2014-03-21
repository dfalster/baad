manipulate <- function(raw) {
  raw        <-  raw[raw[["reference"]]=="Selaya et al. (2008) Journal of Ecology 96: 1211-1221; Selaya & Anten (2010) Ecology 91:1102-1113",]
  raw[["light"]]  <-  raw[["light"]]/55*100

  # Fix grouping. This info is also in 'age', but repeat it here to be safe.
  names(raw)[names(raw) == "group..7."] <- "grouping"
  raw$grouping <- makeGroups(raw, "grouping")
  
  raw
}

