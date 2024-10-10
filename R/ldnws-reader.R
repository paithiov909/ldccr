#' List of categories of the Livedoor News Corpus
#'
#' @param keep Character vector. File names to parse.
#' @returns A character vector.
#' @export
ldnws_categories <- function(keep = c(
  "dokujo-tsushin",
  "it-life-hack",
  "kaden-channel",
  "livedoor-homme",
  "movie-enter",
  "peachy",
  "smax",
  "sports-watch",
  "topic-news"
)) {
  keep <- rlang::arg_match(
    keep,
    c(
      "dokujo-tsushin",
      "it-life-hack",
      "kaden-channel",
      "livedoor-homme",
      "movie-enter",
      "peachy",
      "smax",
      "sports-watch",
      "topic-news"
    ),
    multiple = TRUE
  )
  keep
}


#' @noRd
read_ldnws_impl <- function() {
  function(exdir, keep, collapse, include_title) {
    first_line <- if (include_title) 3 else 4
    res <- purrr::map(keep, function(dir) {
      message("Parsing ", dir, "...")
      files <- file.path(exdir, "text", dir) %>%
        list.files(full.names = TRUE, recursive = FALSE)
      readr::read_delim(
        files,
        delim = "\ufefe", # a dummy delimiter. "Zero Width No-Break Space"
        col_names = "body",
        col_types = "c",
        progress = FALSE,
        id = "file_path",
      )
    }) %>%
      purrr::list_rbind() %>%
      dplyr::filter(
        stringi::stri_detect_regex(
          .data$file_path,
          "(?:LICENSE)|(?:CHANGES)|(?:README)",
          negate = TRUE
        )
      ) %>%
      dplyr::reframe(
        source = .data$body[1],
        time_stamp = .data$body[2],
        title = .data$body[3],
        body = paste(.data$body[first_line:dplyr::n()], collapse = collapse),
        .by = .data$file_path
      ) %>%
      dplyr::mutate(
        category = .data$file_path %>%
          stringi::stri_replace_all_regex("^.+/text/([^/]+)/.+$", "$1") %>%
          factor(levels = keep)
      )
    dplyr::as_tibble(res)
  }
}

#' Read the Livedoor News Corpus
#'
#' Download and read the Livedoor News Corpus.
#' The result of this function is memoised
#' with \code{memoise::memoise} internally.
#'
#' @details
#' This function downloads the Livedoor News Corpus and parses it to a tibble.
#' For details about the Livedoor News Corpus, please see
#' \href{https://www.rondhuit.com/download.html#ldcc}{this page}.
#'
#' @param url String.
#' If left to \code{NULL}, the function will skip downloading the file.
#' @param exdir String. Path to tempolarily untar text files.
#' @param keep Character vector. Categories to parse and keep in data.frame.
#' @param collapse String with which \code{base::paste} collapses lines.
#' @param include_title Logical. Whether to include title in text body field.
#' Defaults to \code{TRUE}.
#' @returns A tibble.
#' @export
read_ldnws <- function(url = "https://www.rondhuit.com/download/ldcc-20140209.tar.gz",
                       exdir = tempdir(),
                       keep = ldnws_categories(),
                       collapse = "\n\n",
                       include_title = TRUE) {
  ## Download gzipped file.
  if (!is.null(url)) {
    tmp <- tempfile(tmpdir = file.path(exdir), fileext = ".tar.gz")
    utils::download.file(url, tmp)
    utils::untar(tmp, exdir = file.path(exdir))
    unlink(tmp)
  } else {
    rlang::inform(
      paste(
        "Skipping to download gzipped file because the 'url' is null.",
        "If something went wrong, remove the exdir/text directory.",
        sep = "\n"
      )
    )
  }

  if (!dir.exists(file.path(exdir, "text"))) {
    return(dplyr::tibble())
  }
  on.exit(message("Done."))
  res <-
    rlang::env_get(
      .pkgenv,
      "read_ldnws",
      default = read_ldnws_impl()
    )(exdir, keep, collapse, include_title)
  res
}
