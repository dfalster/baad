manipulate  <-  function(raw){
  raw2         <-  read.csv('data/Ximenes2004/data2.csv', h=TRUE, stringsAsFactors=FALSE, strip.white=TRUE, check.names=FALSE)
  raw          <-  merge(raw, raw2, by=c('Tree No','Site','Species'))
  raw$h.t      <-  raw[['Tree length (m)']] + raw[['Stump height (cm)']]/100
  raw          <-  raw[!(raw$Species %in% c('DEAD','NCO')), ]
	raw
}
