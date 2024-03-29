#' Data for Textual Entailment
#'
#' @param keep Character vector. File names to parse.
#' @returns tsv file names.
#' @export
jrte_rte_files <- function(keep = c(
                             "rte.nlp2020_base",
                             "rte.nlp2020_append",
                             "rte.lrec2020_surf",
                             "rte.lrec2020_sem_short",
                             "rte.lrec2020_sem_long",
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
      # "rte.lrec2020_mlm",
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
      tsv <- file.path(exdir, "jrte-corpus-master/data", tsv)
      df <-
        readr::read_tsv(tsv, col_names = FALSE, progress = FALSE, show_col_types = FALSE) %>%
        dplyr::transmute(
          example_id = .data$X1,
          label = factor(.data$X2, labels = c("entailment", "non-entailment")),
          hypothesis = .data$X3,
          premise = .data$X4,
          judges = .data$X5,
          reasoning = .data$X6,
          usage = as.factor(.data$X7)
        ) %>%
        dplyr::mutate(across(where(is.character), ~ na_if(., ""))) %>%
        dplyr::mutate(across(where(is.character), ~ na_if(., "null"))) %>%
        tibble::rowid_to_column()
      df %>%
        parse_jrte_judges()
    })
    return(purrr::set_names(res, keep))
  }
}

#' Read the JRTE Corpus
#'
#' Download and read the Japanese Realistic Textual Entailment Corpus.
#' The result of this function is memoised with \code{memoise::memoise} internally.
#'
#' @param url String.
#' @param exdir String. Path to tempolarily unzip text files.
#' @param keep List. File names to parse and keep in returned value.
#' @param keep_rhr Logical. If supplied `TRUE`, keeps `rhr.tsv`.
#' @param keep_pn Logical. If supplied `TRUE`, keeps `pn.tsv`.
#' @returns A list of tibbles.
#' @export
read_jrte <- function(url = "https://github.com/megagonlabs/jrte-corpus/archive/refs/heads/master.zip",
                      exdir = tempdir(),
                      keep = jrte_rte_files(),
                      keep_rhr = FALSE,
                      keep_pn = FALSE) {
  on.exit(message("Done."))

  if (!is.null(url)) {
    tmp <- tempfile(pattern = ".zip", file.path(exdir))
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
    if (keep_rhr) {
      ## rhr
      rhr <-
        readr::read_tsv(file.path(exdir, "jrte-corpus-master/data/rhr.tsv"), col_names = FALSE, progress = FALSE, show_col_types = FALSE) %>%
        dplyr::transmute(
          example_id = .data$X1,
          label = factor(.data$X2, labels = c("reputation", "not_reputation")),
          text = .data$X3,
          judges = .data$X4,
          usage = as.factor(.data$X5)
        ) %>%
        dplyr::mutate(across(where(is.character), ~ na_if(., ""))) %>%
        dplyr::mutate(across(where(is.character), ~ na_if(., "null"))) %>%
        tibble::rowid_to_column()
      res$rhr <- parse_jrte_judges(rhr)
    }
    if (keep_pn) {
      ## pn
      res$pn <-
        readr::read_tsv(file.path(exdir, "jrte-corpus-master/data/pn.tsv"), col_names = FALSE, progress = FALSE, show_col_types = FALSE) %>%
        dplyr::transmute(
          example_id = .data$X1,
          label = factor(.data$X2, labels = c("Positive", "Neutral", "Negative")),
          text = .data$X3,
          judges = .data$X4,
          usage = as.factor(.data$X5)
        ) %>%
        dplyr::mutate(across(where(is.character), ~ na_if(., ""))) %>%
        dplyr::mutate(across(where(is.character), ~ na_if(., "null"))) %>%
        tibble::rowid_to_column()
    }
  }
  return(res)
}
