#' Utilities for Various Japanese Corpora
## ----
#' @importFrom memoise memoise
#' @importFrom purrr map map_dfr walk set_names
#' @importFrom RcppSimdJson fparse
#' @importFrom readr write_lines read_lines read_tsv
#' @importFrom tibble as_tibble rowid_to_column
#' @importFrom utils download.file untar unzip
## ----
#' @docType package
#' @keywords internal
"_PACKAGE"

###

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
