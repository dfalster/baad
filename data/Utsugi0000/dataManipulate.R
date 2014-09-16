manipulate  <-  function(raw){

# Adding branch mass to stem mass
raw$m.st <- raw$m.st + raw$m.br

	raw

}
