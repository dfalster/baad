manipulate <- function(raw) {
  
  raw$grouping <- makeGroups(raw, c("Group", "Last perturbation"))
  
  raw$n.lf <-  raw$n.lf*raw$LeafArea*0.0001/raw$m.lf
  
  # Height to crown base cannot be > h.t; set to NA
  raw$h.c[raw$h.c > raw$h.t] <- NA
  
  raw
}

