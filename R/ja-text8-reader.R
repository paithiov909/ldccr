#' Read the ja.text8 corpus
#'
#' Download and read the ja.text8 corpus as a tibble.
#' @details
#' By default, this function reads the
#' \href{https://github.com/Hironsan/ja.text8}{ja.text8} corpus as a tibble
#' by splitting it into sentences.
#' The ja.text8 as whole corpus consists of over 582,000 sentences,
#' 16,900,026 tokens, and 290,811 vocabularies.
#'
#' @param url String.
#' @param size Integer. If supplied, samples rows by this argument.
#' @returns A tibble.
#' @export
read_ja_text8 <- function(url = "https://s3-ap-northeast-1.amazonaws.com/dev.tech-sketch.jp/chakki/public/ja.text8.zip",
                          size = NULL) {
  tmp <- tempfile(fileext = ".zip")
  utils::download.file(url, tmp)
  on.exit(unlink(tmp))
  sentences <-
    readr::read_file(tmp) %>%
    stringi::stri_split_boundaries(type = "sentence") %>%
    unlist(use.names = FALSE)
  if (!is.null(size)) {
    sentences <- sample(sentences, size, replace = (size > length(sentences)))
  }
  dplyr::tibble(
    doc_id = seq_along(sentences),
    text = sentences
  )
}
