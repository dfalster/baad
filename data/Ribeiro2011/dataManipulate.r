names(raw)[3]         <-  "family"
names(raw)[15:17]     <-  c("location","map", "mat")
names(raw)[13]        <-  "vegetation"
names(raw)[14]        <-  "growingCondition"  
raw$species=raw$Species
