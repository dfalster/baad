make_release_baad_data_zip <- function(dest) {
  path <- file.path(tempfile(), "baad_data")
  dir.create(path, FALSE, TRUE)
  to_copy <- list.files("export", "(csv|bib)$", full.names=TRUE)
  file.copy(to_copy, path)
  colophon(path)
  remake:::zip_dir(path, dest)
}

make_release_baad_code_zip <- function(dest, force=FALSE) {
  if (force || length(system("git status --porcelain", intern=TRUE)) > 0) {
    stop("release not allowed: git working directory is not clean")
  }
  path <- file.path(tempfile(), "baad")
  dir.create(path, FALSE, TRUE)
  system(paste0("git clone . ", path))
  unlink(file.path(path, ".git"), recursive=TRUE)
  remake::make_script("export", filename=file.path(path, "remake.R"))
  colophon(path)
  remake:::zip_dir(path, dest)
}

colophon <- function(path) {
  git_sha <- system("git rev-parse HEAD", intern=TRUE)
  git_url <- paste0("https://github.com/dfalster/baad/commit/", git_sha)
  file <- "colophon.Rmd"
  str <-
    c("# BAAD: a Biomass And Allometry Database for woody plants",
      "",
      sprintf("**Release 1.0.1** git SHA: [%s](%s)", git_sha, git_url),
      "",
      "Session info used to generate this version:",
      "",
      "```{r}",
      "devtools::session_info()",
      "```")
  ## Working directories are a bit of a disaster zone in knitr, so
  ## we'll work around it here:
  owd <- setwd(path)
  on.exit(setwd(owd))
  writeLines(str, file)
  knitr::knit(file, quiet=TRUE)
  file.remove(file)
  invisible(file.path(path, file))
}
