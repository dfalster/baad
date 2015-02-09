make_release_baad_data_zip <- function(dest) {
  path <- file.path(tempfile(), "baad_data")
  dir.create(path, FALSE, TRUE)
  to_copy <- list.files("export", "(csv|bib)$", full.names=TRUE)
  file.copy(to_copy, path)
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
  remake:::zip_dir(path, dest)
}
