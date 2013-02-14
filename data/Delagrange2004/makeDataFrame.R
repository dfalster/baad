#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$total.stem.mass..g.  <-  raw$branch.mass...stem.mass..g.
  raw$Reference            <-  "Delagrange S, Messier C, Lechowicz MJ, Dizengremel P (2004) Physiological, morphological and allocational plasticity in understory deciduous trees: importance of plant size and light availability. Tree Physiology 24:775–784."
  data                 <-  cbind(dataset=studyName, species=raw$Species, grouping=paste(raw$Group, "; Last perturbation = ", raw$Last.perturbation, sep=""), raw[,c(2,4:21,23:29)], stringsAsFactors=FALSE)
}
