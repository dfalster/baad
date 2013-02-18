
#set directories for study
dir.rawData   <-  "data" 
dir.cleanData <-  "output/data"
var.def       <-  read.csv("R/variable_definitions.csv", h=TRUE, stringsAsFactors=FALSE)#variable definitions
var.conv      <-  read.csv("R/variable_conversion.csv", h=TRUE, stringsAsFactors=FALSE)#functions for variable conversion
met.def       <-  read.csv("R/methods_definitions.csv", h=TRUE, stringsAsFactors=FALSE)#definition of methods

#Get list of studies included in database
getStudyNames <-function(){dir("data")}

#make names lowercase
lownames <- function(x)tolower(names(x))





