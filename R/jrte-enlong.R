#' @noRd
parse_reasoning <- function(chr) {
  mtxs <- RcppSimdJson::fparse(chr, empty_array = NA, empty_object = NA)
  mtxs %>%
    imap_dfr(function(elem, idx) {
      if (is.null(elem)) {
        data.frame(
          rowid = idx,
          labels = NA_character_,
          vote = NA_integer_
        )
      } else {
        data.frame(
          rowid = idx,
          reasoning_label = elem[, 1],
          reasoning_votes = as.integer(elem[, 2])
        )
      }
    })
}
