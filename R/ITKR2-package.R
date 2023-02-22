#' Get 'ITK' information
#' @description 'ITK' versions, compile information
#' @returns A list of following items:
#' \describe{
#' \item{\code{version}}{numerical version}
#' \item{\code{release}}{release version}
#' \item{\code{include}}{path to header folders}
#' \item{\code{lib}}{path to library folder}
#' }
#'
#' @examples
#'
#' itk_info()
#'
#'
#' @export
itk_info <- function() {
  release <- readLines(system.file(package = "ITKR2", "ITK", "version"))[[1]]
  include <- list.files(system.file(package = "ITKR2", "include"), pattern = "^ITK-", include.dirs = TRUE, full.names = TRUE, recursive = FALSE)
  include <- include[dir.exists(include)][[1]]
  lib <- system.file(package = "ITKR2", "lib")
  version <- basename(include)
  version <- gsub("^ITK-", "", version)

  list(
    version = version,
    release = release,
    include = include,
    lib = lib
  )
}
