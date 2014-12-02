manipulate  <-  function(raw){

  # Adding branch mass to stem mass
  raw$m.st <- raw$m.st + raw$m.br

  # Recalculate m.so, it is slightly different from m.lf + m.st (likely rounding error)
  raw$m.so <- raw$m.st + raw$m.lf

	raw
}
