manipulate  <-  function(raw){

  # Adding branch mass to stem mass
  raw$m.st <- raw$m.st + raw$m.br

  # Recalculate m.so, it is slightly different from m.lf + m.st (likely rounding error)
  raw$m.so <- raw$m.st + raw$m.lf
  
	# Remove vine species
	vines <- c("Trachelospermum asiaticum", "Akebia trifoliata", "Gardneria nutans", "Cocculus trilobus", "Wisteria floribunda", "Vitis saccharifera", "Hedera rhombea", "Ficus nipponica")

	raw <- subset(raw, !(species %in% vines))

	raw
}
