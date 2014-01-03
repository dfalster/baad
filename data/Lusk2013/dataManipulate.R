manipulate <- function(raw) {
  
  
  # h.c was crown length, should be height to crown base
  raw$h.c <- with(raw, h.t-h.c)
  raw$h.c[raw$h.c < 0 ]<- 0
  
  
  raw
}

