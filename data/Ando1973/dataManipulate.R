manipulate  <-  function(raw){

# Adding branch mass to stem mass
raw$m.st <- raw$m.st + raw$m.br

	# Remove vine species
	vines <- c("Trachelospermum asiaticum", "Akebia trifoliata", "Gardneria nutans", 
             "Cocculus trilobus", "Wisteria floribunda", "Vitis saccharifera", "Hedera rhombea", "Ficus nipponica")

	raw <- subset(raw, !(species %in% vines))

	raw
}
