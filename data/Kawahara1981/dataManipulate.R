manipulate  <-  function(raw){

# Adding branch mass to stem mass
raw$m.st <- raw$m.st + raw$m.br

  # A missing species. Set to 'Unknown'
  raw$species[is.na(raw$species)] <- "Unknown"

	raw
}
