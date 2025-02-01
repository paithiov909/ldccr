#' @import dplyr
#' @importFrom Rcpp sourceCpp
#' @importFrom rlang .data .env
#' @importFrom utils download.file untar unzip globalVariables
#' @useDynLib ldccr, .registration = TRUE
#' @keywords internal
"_PACKAGE"

utils::globalVariables(c("where"))
