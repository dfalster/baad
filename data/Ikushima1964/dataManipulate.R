manipulate  <-  function(raw){

  # zero fix
  raw$a.lf[raw$a.lf == 0] <- NA
	raw$m.lf[raw$m.lf == 0] <- NA

	raw
}
