manipulate <- function(raw) {
  
  # Row 163 is a massive outlier (m.st, but not clear which vars are wrong)
  raw <- raw[-163,]

  raw[["light"]]  <-  raw[["light"]]/55*100
  raw$n.lf        <-  raw$n.lf*raw$a.lf/raw$m.lf

  # Fix grouping. This info is also in 'age', but repeat it here to be safe.
  names(raw)[names(raw) == "group..7."] <-  "grouping"
  raw$grouping                          <-  makeGroups(raw, "grouping")
  
  # Massive outlier : wrong stem area measurement
  raw$a.st[raw$a.st > 0.2] <- NA
  
  # Zero
  raw$a.st[raw$a.st == 0]  <- NA
  
  # Mistake in original processing and a zero fix
  raw$h.c                    <-  raw$h.t - raw$h.c
  raw$h.c[raw$h.c > raw$h.t] <-  NA
  
  raw
}

