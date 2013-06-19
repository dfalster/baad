manipulate <- function(raw) {
  
  raw$grouping <- makeGroups(raw, c("habitat","strata"))
  
  raw$crownlength <- raw[,"height"] - raw[,"hcb"]
  
  raw$sapcb <- (raw$sapcb + raw$sapcb2)/2
  
  # Evidently DBH is in inches in the original file
  raw$dbh <- raw$dbh * 2.54
  
  raw
}

