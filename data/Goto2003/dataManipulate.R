manipulate  <-  function(raw){

# Adding branch mass to stem mass
raw$m.st <- raw$m.st + raw$m.br

	# Remove vine species
	vines <- c("Akebia trifoliata", "Cocculus trilobus", "Wisteria floribunda", "Vitis saccharifera")

	raw <- subset(raw, !(species %in% vines))

	raw
}
