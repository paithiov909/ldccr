#' Data for Textual Entailment
#'
#' @param keep Character vector. File names to parse.
#' @return tsv file names
#'
#' @export
jrte_rte_files <- function(keep = c(
                             "rte.nlp2020_base",
                             "rte.nlp2020_append",
                             "rte.lrec2020_surf",
                             "rte.lrec2020_sem_short",
                             "rte.lrec2020_sem_long",
                             "rte.lrec2020_mlm",
                             "rte.lrec2020_me"
                           )) {
  keep <- match.arg(
    keep,
    c(
      "rte.nlp2020_base",
      "rte.nlp2020_append",
      "rte.lrec2020_surf",
      "rte.lrec2020_sem_short",
      "rte.lrec2020_sem_long",
      "rte.lrec2020_mlm",
      "rte.lrec2020_me"
    ),
    several.ok = TRUE
  )
  return(paste0(keep, ".tsv"))
}

#' @noRd
read_jrte_rte_impl <- function() {
  function(exdir, keep) {
    res <- purrr::map(keep, function(tsv) {
      message("Parsing ", tsv, "...")
      tsv <- file.path(exdir, "data", tsv)
      df <- readr::read_tsv(tsv, col_names = FALSE, progress = FALSE)
      df %>%
        dplyr::transmute(
          example_id = X1,
          label = factor(X2, labels = c("entailment", "non-entailment")),
          hypothesis = X3,
          premise = X4,
          judges = X5,
          reasoning = X6,
          usage = as.factor(X7)
        ) %>%
        dplyr::mutate(across(where(is.character), ~ na_if(., ""))) %>%
        dplyr::mutate(across(where(is.character), ~ na_if(., "null"))) %>%
        tibble::rowid_to_column()
    })
    return(purrr::set_names(res, keep))
  }
}

#' JRTE Coprus Parser
#'
#' Download and read the Japanese Realistic Textual Entailment Corpus.
#' The result of this function is memoised with \code{memoise::memoise} internally.
#'
#' @param url String.
#' @param exdir String. Path to tempolarily unzip text files.
#' @param keep List. File names to parse and keep in data.frame.
#' @return list of data.frames
#'
#' @export
read_jrte_rte <- function(url = "https://github.com/megagonlabs/jrte-corpus/archive/refs/heads/master.zip",
                          exdir = tempdir(),
                          keep = jrte_rte_files()) {
  on.exit(message("Done."))

  ## Download gz file if that untared files never exist.
  ## CHANGES.txt and LICENSE.txt will be deleted.
  if (!is.null(url)) {
    tmp <- tempfile(pattern = ".zip", tmpdir = file.path(exdir))
    download.file(url, tmp)
    unzip(tmp, exdir = file.path(exdir))
    unlink(tmp)
  } else {
    rlang::inform(
      "Skipping to download zipped file because the 'url' is null. If something went wrong, remove the exdir/data directory."
    )
  }

  res <- NULL
  if (!dir.exists(file.path(exdir, "data"))) {
    res <- rlang::env_get(.pkgenv, "read_jrte_rte", default = read_jrte_rte_impl())(exdir, keep)
  }
  return(res)
}
