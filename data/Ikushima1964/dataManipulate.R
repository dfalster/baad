manipulate  <-  function(raw){

	# Remove vine species
	vines <- c("Trachelospermum asiaticum", "Akebia trifoliata", "Gardneria nutans", "Cocculus trilobus", "Wisteria floribunda", "Vitis saccharifera", "Hedera rhombea", "Ficus nipponica")

	raw <- subset(raw, !(species %in% vines))

  # zero fix
  raw$a.lf[raw$a.lf == 0] <- NA
	raw$m.lf[raw$m.lf == 0] <- NA
  
	raw
}
