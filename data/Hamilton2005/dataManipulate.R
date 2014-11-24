manipulate <- function(raw){
  
  raw$barkmass <- raw[["Stem bark (kg)"]] + raw[["Branch bark (kg)"]]
  
  raw$branchmass <- raw[["Branch wood (kg)"]] + raw[["Twigs (kg)"]]
  
  
  raw
}