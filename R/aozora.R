#' Download text file from Aozora Bunko
#'
#' Download a file from specified URL, unzip the file
#' and convert it to UTF8.
#'
#' @seealso \url{https://gist.github.com/ishida-m/7969049}
#'
#' @param url URL of text download link.
#' @param txtname New file name as which text is saved.
#' If `NULL` provided, keeps name of the source file.
#' @param directory Path where new file is saved.
#'
#' @return The path to the new file.
#'
#' @import stringr
#' @importFrom readr write_lines
#' @importFrom utils download.file
#' @importFrom utils unzip
#' @export
aozora <- function(url,
                   txtname = NULL,
                   directory = file.path(getwd(), "cache")) {
  stopifnot(
    is.null(txtname) || is.character(txtname),
    is.character(url),
    !is.na(url) || url != ""
  )

  tmp <- tempfile(fileext = ".zip")
  utils::download.file(url, tmp, quiet = TRUE)
  text_file <- utils::unzip(tmp, exdir = tempdir())
  unlink(tmp)

  if (length(text_file) > 1) {
    location <- stringr::str_which(text_file, ".txt$")
    text_file <- text_file[location]
  }
  if (is.null(txtname)) {
    txtname <- stringr::str_split(basename(text_file), ".txt$", simplify = TRUE)[1]
  }
  connection <- file(text_file, open = "rt")
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
        readr::write_lines(line, outfile, append = TRUE)
      }
    }
    close(outfile)
  }

  close(connection)
  return(new_file)
}
