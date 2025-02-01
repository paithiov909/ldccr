#' Generate random-looking IDs from integer ranks
#'
#' @description
#' `sqids()` is an alternative to [dplyr::row_number()]
#' that generates random-looking IDs from integer ranks
#' using [Sqids (formerly Hashids)](https://sqids.org/).
#'
#' IDs that generated with `sqids()` can be easily decoded back into
#' the original integers using `unsqids()`.
#'
#' @param x
#' For `sqids()`, a vector to rank.
#' You can leave this argument missing to refer to the "current" row number
#' in [dplyr] verbs.
#'
#' For `unsqids()`, a character vector of IDs.
#' @param .salt Integers to use with each value of `x` to generate IDs.
#' @param .ties Method to rank duplicate values.
#' One of `"sequential"`, `"min"`, `"max"`, or `"dense"`.
#' See `ties` argument of [vctrs::vec_rank()] for more details.
#' @returns
#' For `sqids()`, a character vector of IDs.
#'
#' For `unsqids()`, integers.
#' @seealso [sqids/sqids-cpp](https://github.com/sqids/sqids-cpp)
#' @examples
#' ids <- sqids(c(5, 1, 3, 2, 2, NA))
#' ids
#' unsqids(ids)
#'
#' df <- data.frame(
#'   grp = c(1, 1, 1, 2, 2, 2, 3, 3, 3)
#' )
#' # You can use `sqids()` without referencing `x` in dplyr verbs.
#' dplyr::mutate(df, sqids = sqids(), row_id = unsqids(sqids))
#' # Use `.ties` to control how to rank duplicate values.
#' dplyr::mutate(df, sqids = sqids(grp, .ties = "min"), grp_id = unsqids(sqids))
#' # When you need to generate the same IDs for each group, fix the `.salt`:
#' dplyr::mutate(df, sqids = sqids(.salt = 1234L), .by = grp)
#' @export
sqids <- function(x, .salt = sample.int(1e3, 3),
                  .ties = c("sequential", "min", "max", "dense")) {
  if (any(is.na(.salt)) || min(.salt, na.rm = TRUE) < 0L) {
    rlang::abort("Argument `.salt` must be a vector of non-negative integers.")
  }
  if (missing(x)) {
    x <- seq_len(dplyr::n())
  } else {
    .ties <- rlang::arg_match(.ties)
    x <- vctrs::vec_rank(x, ties = .ties, incomplete = "na")
  }
  out <- x
  out[is.na(x)] <- 0L
  out <- vctrs::vec_split(out, seq_along(x))
  out <- sqids_encode(out$val, as.integer(.salt))
  out[is.na(x)] <- NA
  out
}

#' @rdname sqids
#' @export
unsqids <- function(x) {
  if (!is.character(x) || any(stringi::stri_detect_regex(x[!is.na(x)], "[^a-zA-Z0-9]"))) {
    rlang::abort("Argument `x` must be a character vector of valid Sqids.")
  }
  out <- sqids_decode(x) # NA is treated as a string "NA".
  out <- purrr::list_transpose(out)[[1]]
  out[is.na(x)] <- NA
  as.integer(out)
}
