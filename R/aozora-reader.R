#' @noRd
read_aozora_impl <- function() {
  function(url, txtname, directory) {
    stopifnot(
      rlang::is_null(txtname) || rlang::is_character(txtname),
      rlang::is_character(url),
      !is.na(url) || !rlang::is_empty(url)
    )

    tmp <- tempfile(fileext = ".zip")
    download.file(url, tmp, quiet = TRUE)
    text_file <- unzip(tmp, exdir = tempdir())
    unlink(tmp)

    if (length(text_file) > 1) {
      location <- stringi::stri_detect(text_file, regex = ".txt$")
      text_file <- text_file[location][1]
    }
    if (is.null(txtname)) {
      txtname <- stringi::stri_split(basename(text_file), regex = ".txt$")[[1]][1]
    }

    connection <- file(text_file, open = "rt")
    on.exit(close(connection))

    new_file <- file.path(directory, paste0(txtname, ".txt"))

    flag <- TRUE

    out <- connection %>%
      readLines(n = -1L, encoding = "CP932") %>%
      iconv(from = "CP932", to = "UTF-8") %>%
      stringi::stri_replace_all_regex("([:alpha:])[`'^~:&_,'/]", "$1") %>% ## sepatated accents
      purrr::map(function(line) {
        if (stringi::stri_detect_regex(line, "^[-]+") ||
          stringi::stri_detect_regex(line, "^\u5e95\u672c\uff1a") || ## teihon
          stringi::stri_detect_regex(line, "\u3010\u5165\u529b\u8005\u6ce8\u3011")) {
          flag <<- !flag
          return(NA_character_)
        } else {
          dplyr::case_when(
            flag ~ line %>%
              stringi::stri_replace_all_regex("\uff3b\uff03[^\uff3d]*\uff3d", "") %>% ## comments
              stringi::stri_replace_all_regex("\u300a[^\u300b]*\u300b", "") %>% ## ruby
              stringi::stri_replace_all_regex("\uff5c", ""), ## tatebou
            TRUE ~ NA_character_
          )
        }
      }) %>%
      stringi::stri_omit_empty_na()
    readr::write_lines(out, new_file)
    return(new_file)
  }
}

#' Download text file from Aozora Bunko
#'
#' Download a file from specified URL, unzip and convert it to UTF-8.
#'
#' @param url URL of text download link.
#' @param txtname New file name as which text is saved.
#' If `NULL` provided, keeps name of the source file.
#' @param directory Path where new file is saved.
#' @returns The path to the file downloaded.
#' @export
read_aozora <- function(url = "https://www.aozora.gr.jp/cards/000081/files/472_ruby_654.zip",
                        txtname = NULL,
                        directory = file.path(getwd(), "cache")) {
  res <- NULL
  if (dir.exists(directory)) {
    res <-
      rlang::env_get(.pkgenv, "read_aozora", default = read_aozora_impl())(url, txtname, directory)
  }
  return(res)
}
