manipulate <- function(raw) {
  raw[["Bark_Stemwood"]]                    <-  raw[["Bark"]] + raw[["Stemwood"]]
  raw
}

