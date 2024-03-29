#' List of categories of the Livedoor News Corpus
#'
#' @param keep Character vector. File names to parse.
#' @returns A list.
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
  keep <- match.arg(
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
    several.ok = TRUE
  )
  return(as.list(keep))
}


#' @noRd
read_ldnws_impl <- function() {
  function(exdir, keep, collapse) {
    res <- purrr::map(keep, function(dir) {
      files <- list.files(file.path(exdir, "text", dir), full.names = TRUE, recursive = FALSE)
      message("Parsing ", dir, "...")
      purrr::map(files, function(file) {
        lines <- readr::read_lines(file)
        data.frame(
          category = dir,
          file_path = file,
          source = lines[1],
          time_stamp = lines[2],
          body = paste(lines[3:length(lines)], collapse = collapse)
        )
      })
    }) %>%
      purrr::flatten() %>%
      purrr::list_rbind() %>%
      dplyr::mutate(category = as.factor(.data$category))
    return(tibble::as_tibble(res))
  }
}

#' Read the Livedoor News Corpus
#'
#' Download and read the Livedoor News Corpus.
#' The result of this function is memoised with \code{memoise::memoise} internally.
#'
#' @details
#' This function downloads the Livedoor News Corpus and parses it to a tibble.
#' For details about the Livedoor News Corpus, please see
#' \href{https://www.rondhuit.com/download.html#ldcc}{this page}.
#'
#' @param url String.
#' @param exdir String. Path to tempolarily untar text files.
#' @param keep List. Categories to parse and keep in data.frame.
#' @param collapse String with which \code{base::paste} collapses lines.
#' @returns A tibble.
#' @export
read_ldnws <- function(url = "https://www.rondhuit.com/download/ldcc-20140209.tar.gz",
                       exdir = tempdir(),
                       keep = ldnws_categories(),
                       collapse = "\n\n") {
  on.exit(message("Done."))

  ## Download gzipped file.
  ## CHANGES.txt and LICENSE.txt will be deleted.
  if (!is.null(url)) {
    tmp <- tempfile(pattern = ".tar.gz", tmpdir = file.path(exdir))
    download.file(url, tmp)
    untar(tmp, exdir = file.path(exdir))
    text_dirs <- list.dirs(file.path(exdir, "data"), recursive = FALSE)
    purrr::walk(paste(text_dirs, c("LICENSE.txt", "CHANGES.txt"), sep = "/"), function(file) {
      try(unlink(file.path(file)))
    })
    unlink(tmp)
  } else {
    rlang::inform(
      "Skipping to download zipped file because the 'url' is null. If something went wrong, remove the exdir/data directory."
    )
  }

  res <- NULL
  if (!dir.exists(file.path(exdir, "data"))) {
    res <-
      rlang::env_get(.pkgenv, "read_ldnws", default = read_ldnws_impl())(exdir, keep, collapse)
  }

  return(res)
}
