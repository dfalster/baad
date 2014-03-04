manipulate  <-  function(raw){
  raw2         <-  read.csv('data/Ximenes2004/data2.csv', h=TRUE, 
                            stringsAsFactors=FALSE, strip.white=TRUE, check.names=FALSE)
  raw          <-  merge(raw, raw2, by=c('Tree No','Site','Species'))
  raw$h.t      <-  raw[['Tree length (m)']] + raw[['Stump height (cm)']]/100
  
  # when h.t is less than 2m, height is actually missing (it is just stump height)
  raw$h.t[raw$h.t < 2] <- NA
  
  raw          <-  raw[!(raw$Species %in% c('DEAD','NCO')), ]
	raw
}
