#' Utilities for Various Japanese Corpora
## ----
#' @import dplyr
#' @import rlang
#' @importFrom utils download.file untar unzip
## ----
#' @docType package
#' @keywords internal
"_PACKAGE"

#' @importFrom utils globalVariables
utils::globalVariables("where")

#' Package internal environment
#' @noRd
.pkgenv <- rlang::env()

#' onLoad
#' @noRd
#' @param libname libname
#' @param pkgname pkgname
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  rlang::env_bind(.pkgenv, "read_aozora" = memoise::memoise(read_aozora_impl()))
  rlang::env_bind(.pkgenv, "read_ldnws" = memoise::memoise(read_ldnws_impl()))
  rlang::env_bind(.pkgenv, "read_jrte_rte" = memoise::memoise(read_jrte_rte_impl()))
}

#' Read srt file
#'
#' @param path Path to srt file.
#' @param collapse String.
#' @return A tibble.
#' @export
#' @useDynLib ldccr, .registration = TRUE
read_srt <- function(path, collapse = "\n") {
  path <- path.expand(path)
  stopifnot(
    is.character(collapse),
    file.exists(path)
  )
  ret <- read_srt_impl(path, collapse = collapse)

  ret$start <- stringi::stri_replace_all_regex(ret$start, pattern = ",", replacement = "\\.")
  ret$end <- stringi::stri_replace_all_regex(ret$end, pattern = ",", replacement = "\\.")

  tibble::as_tibble(ret)
}
