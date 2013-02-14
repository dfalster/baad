#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$n.lf.per  <-  (raw$n.lf.per/100) * raw$lf.ma.g.m2 # this transforms it from percentage (/unit mass) to /unit area --> final unit g/m2
  raw$reference[raw$reference %in% c(unique(raw$reference)[1])]  <-  "Kenzo T, Ichie T, Hattori D, Itioka T, Handa C, Ohkubo T, Kendawang JJ, Nakamura M, Sakaguchi M, Takahashi N, Okamoto M, Tanaka-Oda A, Sakurai K, Ninomiya I (2009) Development of allometric relationships for accurate estimation of above- and below-ground biomass in tropical secondary forests in Sarawak, Malaysia. Journal of Tropical Ecology 25:371–386."
  raw$reference[raw$reference %in% c(unique(raw$reference)[2])]  <-  "Kenzo T et al. 2008 unpublished"
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$group, raw$location, raw$contributor, sep="; "), raw[,c(2, 4:24, 26:ncol(raw))], stringsAsFactors=FALSE)
}
