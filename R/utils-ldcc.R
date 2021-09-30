#' Check if scalars are blank
#'
#' A port of \code{rapportools::is.empty()}.
#'
#' @param x Object to check its emptiness.
#' @param trim Logical.
#' @param ... Additional arguments for \code{base::sapply()}.
#'
#' @return Logical.
#'
#' @export
is_blank <- function(x, trim = TRUE, ...) {
  if (!is.list(x) && length(x) <= 1) {
    if (is.null(x)) {
      return(TRUE)
    }
    dplyr::case_when(
      is.na(x) ~ TRUE,
      is.nan(x) ~ TRUE,
      is.character(x) && nchar(ifelse(trim, stringr::str_trim(x), x)) == 0 ~ TRUE,
      TRUE ~ FALSE
    )
  } else {
    if (length(x) == 0) {
      return(TRUE)
    }
    sapply(x, is_blank, trim = trim, ...)
  }
}

#' Convert characters following the rules of 'neologd'
#'
#' Convert the characters into normalized style
#' basing on rules that is recommended for using the Neologism dictionary for MeCab.
#'
#' @seealso \url{https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja}
#'
#' @param str Input vector.
#' @return a character
#'
#' @export
ldcc_jnormalize <- function(str) {
  res <- ldcc_conv_normalize(str)
  res <- stringr::str_replace_all(
    res,
    c(
      "\u2019" = "\'",
      "\u201d" = "\""
    )
  ) %>%
    stringr::str_replace_all(
      "[\\-\u02d7\u058a\u2010\u2011\u2012\u2013\u2043\u207b\u208b\u2212]+", "-"
    ) %>%
    stringr::str_replace_all(
      "[\ufe63\uff0d\uff70\u2014\u2015\u2500\u2501\u30fc]+", enc2utf8("\u30fc")
    ) %>%
    stringr::str_replace_all(
      "([:blank:]){2,}", " "
    ) %>%
    stringr::str_replace_all(
      stringr::str_c(
        "([\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]+)",
        "[[:blank:]]*",
        "([\u0021-\u007e[:punct:]]+)"
      ),
      "\\1\\2"
    ) %>%
    stringr::str_replace_all(
      stringr::str_c(
        "([\u0021-\u007e\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]*)",
        "[[:blank:]]*",
        "([\uff10-\uff19\u3041-\u3093\u30a1-\u30f6\u30fc\u4e00-\u9fa0[:punct:]]+)"
      ),
      "\\1\\2"
    )
  res <- stringr::str_remove_all(res, "[~\u223c\u223e\u301c\u3030\uff5e]+")
  res <- stringr::str_trim(res)
  res <- stringr::str_remove_all(res, "[[:cntrl:]]+")
  return(res)
}

#' @noRd
#' @export
ldcc_rep_iterationmark_double <- function(str) {
  if (is.character(str) && length(str) == 1L) {
    if (stringi::stri_detect(str, regex = "(\uff0f[\u2033\u309b\"]?\uff3c)")) {
      tmp <- stringi::stri_replace_all(str, "", regex = "[\u2033\u309b\"]+")
      tmp <- stringi::stri_replace_all(tmp, replacement = "\"", regex = "[(\uff0f\uff3c)]")
      tmp <- stringi::stri_split_boundaries(tmp, type = "character")[[1]]
      if (length(tmp) > 3) {
        idx <- stringr::str_which(tmp, "\"")
        if (!identical(idx, integer(0)) && min(idx) > 2) tmp[idx] <- tmp[idx - 2L]
      }
    }
    return(stringi::stri_c(tmp, collapse = ""))
  } else {
    if (is_blank(str, trim = FALSE) || length(str) == 1L) {
      rlang::abort("'ldcc_rep_iterationmark_double' function gets character vector only.")
    }

    sapply(str, ldcc_rep_iterationmark_double, USE.NAMES = FALSE)
  }
}

#' @noRd
#' @export
ldcc_rep_iterationmark_single <- function(str, pattern = "[\u3003\u309d\u30fd]") {
  if (is.character(str) && length(str) == 1L) {
    tmp <- stringi::stri_trans_nfkd(str)
    tmp <- stringr::str_split(tmp, pattern = "")[[1]]
    if (length(tmp) > 1) {
      idx <- stringr::str_which(tmp, pattern = pattern)
      if (!identical(idx, integer(0)) && min(idx) > 1) tmp[idx] <- tmp[idx - 1L]
    }
    return(stringi::stri_c(tmp, collapse = ""))
  } else {
    if (is_blank(str, trim = FALSE) || length(str) == 1L) {
      rlang::abort("'ldcc_rep_iterationmark_single' function gets character vector only.")
    }

    sapply(str, ldcc_rep_iterationmark_single, USE.NAMES = FALSE)
  }
}

#' @aliases ldcc_rep_iterationmark_single
ldcc_rep_iterationmark <- ldcc_rep_iterationmark_single

#####

## Partial port from uribo/zipangu (zipangu/R/convert-str.R)
## ----

#' @noRd
#' @export
ldcc_conv_hirakana <- function(str, to = c("hiragana", "katakana")) {
  rlang::arg_match(to)
  if (to == "hiragana") {
    stringi::stri_trans_general(str, "Katakana-Hiragana")
  } else {
    stringi::stri_trans_general(str, "Hiragana-Katakana")
  }
}

#' @noRd
#' @export
ldcc_conv_zenhan <- function(str, to = c("zenkaku", "hankaku")) {
  rlang::arg_match(to)
  switch(to,
    "zenkaku" = stringi::stri_trans_general(str, "Halfwidth-Fullwidth"),
    "hankaku" = stringi::stri_trans_general(str, "Fullwidth-Halfwidth")
  )
}

#' @noRd
#' @export
ldcc_conv_romanhira <- function(str, to = c("roman", "hiragana")) {
  rlang::arg_match(to)
  switch(to,
    "roman" = stringi::stri_trans_general(str, "Any-Latin"),
    "hiragana" = stringi::stri_trans_general(str, "Latin-Hiragana")
  )
}

#' @noRd
#' @importFrom stringi stri_trans_nfkc
#' @export
ldcc_conv_normalize <- function(str, ...) {
  stri_trans_nfkc(str)
}
