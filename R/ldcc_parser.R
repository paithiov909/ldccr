#' List of Categories
#' @return list
#' @export
ldcc_categories <- function() {
  list(
    "dokujo-tsushin",
    "it-life-hack",
    "kaden-channel",
    "livedoor-homme",
    "movie-enter",
    "peachy",
    "smax",
    "sports-watch",
    "topic-news"
  )
}

#' Corpus Reader
#' @noRd
#' @return memoised function
#' @import purrr
#' @importFrom vroom vroom_lines
#' @import memoise
#' @keywords internal
ldcc_reader <- function() {
  f <- function(exdir, keep, collapse) {
    purrr::map_dfr(keep, function(dir) {
      files <- list.files(file.path(exdir, "text", dir), full.names = TRUE, recursive = FALSE)
      message("Parsing ", dir, "...")
      purrr::map_dfr(files, function(file) {
        lines <- vroom::vroom_lines(file)
        return(data.frame(
          category = dir,
          file_path = file,
          source = lines[1],
          time_stamp = lines[2],
          body = paste(lines[3:length(lines)], collapse = collapse)
        ))
      })
    })
  }
  return(memoise::memoise(f))
}

#' Livedoor News Corpus Parser
#'
#' Download Livedoor News Corpus and parse it to data.frame.
#' The result of this function is memoised with \code{memoise::memoise} internally.
#'
#' @seealso \url{https://www.rondhuit.com/download.html#ldcc}
#'
#' @param url string.
#' @param exdir string. path to save text files.
#' @param keep list. categories to parse and keep in data.frame.
#' @param collapse string with which \code{paste()} collapses lines.
#' @return data.frame
#'
#' @import utils
#' @export
parse_ldcc <- (function() {
  read_corpus <- ldcc_reader()
  function(url = "https://www.rondhuit.com/download/ldcc-20140209.tar.gz",
           exdir = tempdir(),
           keep = ldcc_categories(),
           collapse = "\n\n") {
    ## Download file
    if (!dir.exists(file.path(exdir, "text"))) {
      tmp <- tempfile(pattern = ".tar.gz", tmpdir = file.path(exdir))
      utils::download.file(url, tmp)
      utils::untar(tmp, exdir = file.path(exdir))
      text_dirs <- list.dirs(file.path(exdir, "text"), recursive = FALSE)
      sapply(paste(text_dirs, "LICENSE.txt", sep = "/"), function(license) {
        try(unlink(file.path(license))) ## Delete LICENSE file
      })
      unlink(tmp)
    }
    ## Read texts
    return(read_corpus(exdir, keep, collapse))
  }
})()
