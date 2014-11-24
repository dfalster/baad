manipulate <- function(raw) {
  raw[["stem dry mass (g)"]]  <-  raw[["stem dry mass (g)"]] + raw[["branch dry mass (g)"]]
  
  raw
}

