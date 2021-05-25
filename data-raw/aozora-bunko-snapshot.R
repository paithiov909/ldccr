
tmp <- tempfile()
download.file("http://www.aozora.gr.jp/index_pages/list_person_all_extended_utf8.zip", destfile = tmp)
list_all <- unzip(tmp, exdir = tempdir())

AozoraBunkoSnapshot <- readr::read_csv(list_all)

usethis::use_data(AozoraBunkoSnapshot, overwrite = TRUE)
