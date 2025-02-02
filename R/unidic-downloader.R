#' @rdname unidic-downloader
#' @export
unidic_availables <- function() {
  RcppSimdJson::fload(
    "https://raw.githubusercontent.com/polm/unidic-py/master/dicts.json"
  )
}

#' Download and unzip 'UniDic'
#'
#' Downloads 'UniDic' of specified version into `dirname`.
#' This function is a partial port of
#' [polm/unidic-py](https://github.com/polm/unidic-py).
#' Note that to unzip dictionary will take up 770MB on disk after downloading.
#'
#' @param version String; version of 'UniDic'.
#' @param dirname String; directory to unzip the dictionary.
#' @returns Full path to `dirname` is returned invisibly.
#' @export
#' @rdname unidic-downloader
download_unidic <- function(version = "latest", dirname = "unidic") {
  json <- unidic_availables()
  version <- rlang::arg_match(version, values = names(json))

  if (yesno::yesno(sprintf("Download UniDic version %s ?", version))) {
    rlang::inform(
      sprintf("Downloading UniDic version %s ...", version)
    )
    temp <- tempfile(fileext = ".zip")
    utils::download.file(json[[version]]$url, temp)
    utils::unzip(temp, exdir = file.path(dirname))
  }
  on.exit(
    rlang::inform(
      sprintf("Downloaded UniDic version %s", version)
    )
  )
  return(invisible(file.path(dirname)))
}
