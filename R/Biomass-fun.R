
#set directories for study
dir.rawData   <-  "data" 
dir.cleanData <-  "output/data"
var.def       <-  read.csv("R/tables/variableDefinitions.csv", h=TRUE, stringsAsFactors=FALSE)#variable definitions
met.def       <-  read.csv("R/tables/methodsDefinitions.csv", h=TRUE, stringsAsFactors=FALSE)#definition of methods

#Get list of studies included in database
getStudyNames <-function(){dir("data")}

#make names lowercase
lownames <- function(x)tolower(names(x))





