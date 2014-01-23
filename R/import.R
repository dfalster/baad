checkPackage  <-  function(package.name){
  if(package.name %in% .packages(all.available=TRUE)){
    library(package.name, character.only=TRUE, quietly=TRUE)  
  } else {
    install.packages(package.name)
    library(package.name, character.only=TRUE, quietly=TRUE)
  }
  
}

sapply(c('bibtex', 'devtools', 'maps', 'mapdata', 'gdata', 'smatr'), checkPackage)
rm(checkPackage)


.libPaths(c("lib", .libPaths()))  # will cause us to use local version of dataMashR

if(!file.exists("lib/dataMashR")){
	warning("We recomment you install dataMashR in local directory before proceeding")
}

library(dataMashR)

