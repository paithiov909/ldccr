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
      location <- stringr::str_which(text_file, ".txt$")
      text_file <- text_file[location]
    }
    if (is.null(txtname)) {
      txtname <- stringr::str_split(basename(text_file), ".txt$", simplify = TRUE)[1]
    }

    connection <- file(text_file, open = "rt")
    on.exit(close(connection))

    new_file <- file.path(directory, paste0(txtname, ".txt"))

    if (file.create(new_file)) {
      outfile <- file(new_file, open = "ab", encoding = "UTF-8")

      flag <- TRUE
      reg1 <- enc2utf8("^\u5e95\u672c")
      reg2 <- enc2utf8("\u3010\u5165\u529b\u8005\u6ce8\u3011")
      reg3 <- enc2utf8("\uff3b\uff03[^\uff3d]*\uff3d")
      reg4 <- enc2utf8("\u300a[^\u300b]*\u300b")
      reg5 <- enc2utf8("\uff5c")

      lines <- readLines(connection, n = -1L, encoding = "CP932")
      lines <- iconv(lines, from = "CP932", to = "UTF-8")
      lines <- ldcc_conv_normalize(lines)

      for (line in lines) {
        if (stringr::str_detect(line, reg1)) break
        if (stringr::str_detect(line, reg2)) break
        if (stringr::str_detect(line, "^[-]+")) {
          flag <- !flag
          next
        }
        if (flag) {
          line <- line %>%
            stringr::str_replace("^[-]+", "") %>%
            stringr::str_replace_all(reg3, "") %>%
            stringr::str_replace_all(reg4, "") %>%
            stringr::str_replace_all(reg5, "")
          write_lines(line, outfile, append = TRUE)
        }
      }
      close(outfile)
    }
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
#'
#' @return The path to the file downloaded.
#'
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
