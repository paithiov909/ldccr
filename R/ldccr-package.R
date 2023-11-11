#' Utilities for Various Japanese Corpora
## ----
#' @import dplyr
#' @import rlang
#' @importFrom utils download.file untar unzip
#' @useDynLib ldccr, .registration = TRUE
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
