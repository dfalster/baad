manipulate  <-  function(raw){

	# Remove vine species
	vines <- c("Trachelospermum asiaticum", "Akebia trifoliata", "Gardneria nutans", 
             "Cocculus trilobus", "Wisteria floribunda", "Vitis saccharifera", "Hedera rhombea", "Ficus nipponica")

	raw <- subset(raw, !(species %in% vines))

  # A missing species. Set to 'Unknown'
  raw$species[is.na(raw$species)] <- "Unknown"
  
	raw
}
