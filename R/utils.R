#' Utility functions
#'
#' `r lifecycle::badge("experimental")`
#' These functions are experimental and may withdraw in the future.
#'
#' @rdname utils
#' @name utils
NULL

#' @param text A character vector.
#' @param replacement String.
#' @export
#' @rdname utils
clean_url <- function(text, replacement = "") {
  regexp <- "(https?|ftp)://([[a-zA-Z0-9]-]+\\.)+[[a-zA-Z0-9]-]+(/[[a-zA-Z0-9]- ./?%&=~]*)?"
  stringi::stri_replace_all_regex(text, pattern = regexp, replacement = replacement)
}

#' @param text A character vector.
#' @param replacement String.
#' @export
#' @rdname utils
clean_emoji <- function(text, replacement = "") {
  # https://github.com/exploratory-io/exploratory_func/blob/master/R/string_operation.R#L787
  regexp <- "\\p{EMOJI}|\\p{EMOJI_PRESENTATION}|\\p{EMOJI_MODIFIER_BASE}|\\p{EMOJI_MODIFIER}\\p{EMOJI_COMPONENT}"
  # it seems above condition does not cover all emojis.
  # So we will manually add below emojis. (ref: https://github.com/gagolews/stringi/issues/279)
  regexp <- stringi::stri_c(regexp, "|\U0001f970|\U0001f975|\U0001f976|\U0001f973|\U0001f974|\U0001f97a|\U0001f9b8|\U0001f9b9|\U0001f9b5|\U0001f9b6|\U0001f9b0|\U0001f9b1|\U0001f9b2", sep = "")
  regexp <- stringi::stri_c(regexp, "|\U0001f9b3|\U0001f9b4|\U0001f9b7|\U0001f97d|\U0001f97c|\U0001f97e|\U0001f97f|\U0001f99d|\U0001f999|\U0001f99b|\U0001f998|\U0001f9a1|\U0001f9a2", sep = "")
  regexp <- stringi::stri_c(regexp, "|\U0001f99a|\U0001f99c|\U0001f99e|\U0001f99f|\U0001f9a0|\U0001f96d|\U0001f96c|\U0001f96f|\U0001f9c2|\U0001f96e|\U0001f9c1|\U0001f9ed|\U0001f9f1", sep = "")
  regexp <- stringi::stri_c(regexp, "|\U0001f6f9|\U0001f9f3|\U0001f9e8|\U0001f9e7|\U0001f94e|\U0001f94f|\U0001f94d|\U0001f9ff|\U0001f9e9|\U0001f9f8|\U0001f9f5|\U0001f9f6|\U0001f9ee", sep = "")
  regexp <- stringi::stri_c(regexp, "|\U0001f9fe|\U0001f9f0|\U0001f9f2|\U0001f9ea|\U0001f9eb|\U0001f9ec|\U0001f9f4|\U0001f9f7|\U0001f9f9|\U0001f9fa|\U0001f9fb|\U0001f9fc|\U0001f9fd", sep = "")
  regexp <- stringi::stri_c(regexp, "|\U0001f9ef|\u267e", sep = "")
  # Handle zero-width joiner (\u200d) prefixing another emoji. https://en.wikipedia.org/wiki/Zero-width_joiner
  # Also handle variation selector (\ufe0e, \ufe0f) suffixing emoji. https://en.wikipedia.org/wiki/Variation_Selectors_(Unicode_block)
  regexp <- stringi::stri_c("\u200d?(", regexp, ")(\ufe0e|\ufe0f)?", sep = "")
  stringi::stri_replace_all_regex(text, pattern = regexp, replacement = replacement)
}

#' @param date Dates.
#' @param era String.
#' @export
#' @rdname utils
is_within_era <- function(date, era) {
  stringi::stri_datetime_format(
    as.Date(date),
    format = "G",
    locale = "ja-u-ca-japanese"
  ) == era
}

#' @param date Dates.
#' @param format String.
#' @export
#' @rdname utils
parse_to_jdate <- function(date, format) {
  if (missing(format)) {
    format <- enc2utf8("Gy\u5e74M\u6708d\u65e5")
  }
  stringi::stri_datetime_format(
    as.Date(date),
    format = format,
    locale = "ja-u-ca-japanese"
  )
}
