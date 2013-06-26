library(bibtex, quietly=TRUE)


if("dataMashR" %in% .packages(all.available=TRUE)){
  library(dataMashR)  
} else {
  library(devtools)
  install_github("dataMashR","dfalster")
  library(dataMashR)
}

