#' Parse reasoning column of 'rte.*.tsv'
#'
#' @param tbl A tibble returned from \code{read_jrte} which name is `rte.*.tsv`.
#' @returns A tibble.
#' @export
parse_jrte_reasoning <- function(tbl) {
  reasons <-
    RcppSimdJson::fparse(tbl$reasoning, empty_array = NA, empty_object = NA) %>%
    purrr::imap_dfr(function(elem, idx) {
      if (anyNA(elem)) {
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

  res <- tbl %>%
    dplyr::select(!"reasoning") %>%
    dplyr::left_join(reasons, by = "rowid")

  dplyr::as_tibble(res)
}

#' Parse judges column of 'rte.*.tsv'
#'
#' @param tbl A tibble returned from \code{read_jrte} which name is `rte.*.tsv`
#' (this function cannot parse judges of the `pn` dataset).
#' @returns A tibble.
#' @keywords internal
parse_jrte_judges <- function(tbl) {
  judges <-
    RcppSimdJson::fparse(tbl$judges, empty_array = NA, empty_object = NA) %>%
    purrr::imap(function(elem, idx) {
      if (anyNA(elem)) {
        data.frame(
          rowid = idx,
          n_entailment = NA_integer_,
          n_non_entailment = NA_integer_
        )
      } else {
        data.frame(
          rowid = idx,
          n_entailment = as.integer(elem$`0`),
          n_non_entailment = as.integer(elem$`1`)
        )
      }
    }) %>%
    purrr::list_rbind()

  res <- tbl %>%
    dplyr::select(!"judges") %>%
    dplyr::left_join(judges, by = "rowid")

  dplyr::as_tibble(res)
}
