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

if("dataMashR" %in% .packages(all.available=TRUE)){
  library(dataMashR)  
} else {
  library(devtools)
  install_github("dataMashR","dfalster")
  library(dataMashR)
}

