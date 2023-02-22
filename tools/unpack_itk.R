#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if(length(args) == 0 || !nzchar(trimws(args[[1]]))) {
  # tmpdir <- tools::R_user_dir('ITKR2', which = "cache")
  stop("Invalid ITK unpack path.")
} else {
  tmpdir <- args[[1]]
}

# ---- variables ---------------------------------------------------------------
itk_tarball <- "inst/ITK/ITK-sourcefile.tar.gz"
itk_versionfile <- "inst/ITK/version"
itk_tempdir <- file.path(tmpdir, "ITKR2-builder")
itk_version <- readLines(itk_versionfile)

# ---- Extract -----------------------------------------------------------------
itk_buildpath <- file.path(itk_tempdir, "ITK-build")

# TODO: check if itk_buildpath/version file exists
cached_version <- ""
cached_version_path <- file.path(itk_buildpath, "version")
if(file.exists(cached_version_path)) {
  cached_version <- readLines(cached_version_path)
}
if( !identical(itk_version, cached_version) ) {
  if(file.exists(itk_tempdir)) {
    unlink(itk_tempdir, recursive = TRUE, force = TRUE)
  }
  dir.create(itk_tempdir, showWarnings = FALSE, recursive = TRUE)
  utils::untar(itk_tarball, exdir = itk_tempdir)
  file.rename(
    from = file.path(itk_tempdir, itk_version),
    to = file.path(itk_tempdir, "ITK")
  )
  dir.create(itk_buildpath, showWarnings = FALSE, recursive = TRUE)
}

