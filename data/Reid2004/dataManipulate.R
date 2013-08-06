manipulate <- function(raw) {

  # some bad missing values
  raw[raw == "#N/A"] <- NA
  
  # Missing growingCondition ("?") denotes trees grown on
  # edge of road. Set to FW as well, still fitting.
  raw$growingCondition[raw$growingCondition == "?"] <- "FW"
  
  # dont use a.cp or a.cs, both calculated from d.cr
  raw$a.cs <- NULL
  raw$a.cp <- NULL
  
  raw
}
