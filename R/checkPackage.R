checkPackage  <-  function(package.name){
  if(package.name %in% .packages(all.available=TRUE)){
    library(package.name, character.only=TRUE, quietly=TRUE)  
  } else {
    install.packages(package.name)
    library(package.name, character.only=TRUE, quietly=TRUE)
  }
  
}