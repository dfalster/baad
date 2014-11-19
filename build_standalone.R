source("functions_steps.R")
source("functions_metadata.R")
source("functions_support.R")
source("functions_combine.R")

source("functions_evil.R")

res <- build_baad()
cmp <- readRDS("baad_ref2.rds")
all.equal(res, cmp)

cmp <- readRDS("baad_ref.rds")

identical(names(res), names(cmp))

cols <- setdiff(names(res), c("references", "bibtex"))
all.equal(res[cols], cmp[cols])

## There are a couple of issues here:
all.equal(res$references, cmp$references)
all.equal(res$bibtex, cmp$bibtex)

## saveRDS(res, "baad_ref2.rds")

