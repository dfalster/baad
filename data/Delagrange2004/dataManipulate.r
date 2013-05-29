manipulate <- function(raw) {
  raw$grouping             <- makeGroups(raw, c("Group", "Last perturbation"))
  raw$n.lf   <-  raw$n.lf*raw$LeafArea*0.0001/raw$m.lf
  
  raw
}

