
tmp <- tempfile()
download.file("http://www.aozora.gr.jp/index_pages/list_person_all_extended_utf8.zip", destfile = tmp)
list_all <- unzip(tmp, exdir = tempdir())

AozoraBunkoSnapshot <- readr::read_csv(list_all, guess_max = 2000)
# readr::problems()

AozoraBunkoSnapshot <- AozoraBunkoSnapshot |>
  dplyr::mutate(作品ID = as.integer(作品ID), 人物ID = as.integer(人物ID)) |>
  dplyr::mutate_if(is.integer, ~ as.factor(.))

usethis::use_data(AozoraBunkoSnapshot, overwrite = TRUE)
