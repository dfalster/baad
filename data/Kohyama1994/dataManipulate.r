manipulate <- function(raw) {
  
  # Remove zero SLA values
  raw$SLA.cm2.g[raw$SLA.cm2.g == 0] <- NA
    
  # Remove zero LA values
  raw$Al.cm2[raw$Al.cm2 == 0] <- NA
  
  raw
}

