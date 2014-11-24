manipulate <- function(raw) {
  
  # Obvious typo fix.
  raw[["lma (g cm-2)"]][raw[["lma (g cm-2)"]] == 0.3498] <- 0.003498
  
  raw
}

