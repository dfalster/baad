#!/usr/bin/env Rscript

files <- list.files("data", pattern="csv", full.names=TRUE, recursive=TRUE)

files <- files[-grep("data.csv", files)]
files <- files[-grep("data2.csv", files)]
files <- files[-grep("review", files)]

for(f in files) {
	data <- read.csv(f, stringsAsFactors=FALSE, check.names=FALSE, strip.white=TRUE)
	write.csv(data, f, row.names =FALSE)
}
