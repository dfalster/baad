raw$Leaf.area  <-raw$X
raw$stem       <-raw$stem+raw$branch
raw$m.rf       <-raw$X5.Oct + raw$Oct.15
raw$m.rc       <-raw$X15...20 + raw$X20....stump
raw$grouping=paste("Harvested on ", raw$Harvested, "; Plot = ", raw$plot, "; Treatment = ", raw$treatment, "; seedling = ", raw$seedling, sep="")
