

# retrieve family names (and other info) with taxise

install.packages("devtools")
library(devtools)
install_github("taxize_", "ropensci")
library(taxize)
tax_name(query = "Poa annua", get = "family")
splist <- c("Heliathus annuus", "Abies procera", "Poa annua", "Platanus occidentalis",
"Carex abrupta", "Arctostaphylos canescens", "Ocimum basilicum", "Vicia faba",
"Quercus kelloggii", "Lactuca serriola")
tpl_search(taxon = splist)
species <- c("Poa annua", "Abies procera", "Helianthus annuus", "Coffea arabica")
famnames <- sapply(species, itis_name, get = "family", USE.NAMES = F)
species <- c("Poa annua", "Abies procera", "Helianthus annuus", "Coffea arabica")
famnames <- sapply(species, tax_name, get = "family", USE.NAMES = F)
famnames
tax_name(query = "Poa annua", get = "family")


Also Retrive higher order names. For more info see
- http://schamberlain.github.io/2012/12/taxize/#comment-865718861
  