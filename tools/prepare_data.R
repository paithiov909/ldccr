library(tidyverse)

#### AozoraBunkoSnapshot ####
tmp <- tempfile()
download.file("http://www.aozora.gr.jp/index_pages/list_person_all_extended_utf8.zip", destfile = tmp)
list_all <- unzip(tmp, exdir = tempdir())
AozoraBunkoSnapshot <- readr::read_csv(list_all)
usethis::use_data(AozoraBunkoSnapshot, overwrite = TRUE)

#### Miyazawa_Kenji_list ####
MiyazawaKenji <- readr::read_csv("data-raw/miyazawa_kenji_list.csv")
usethis::use_data(MiyazawaKenji, overwrite = TRUE)

#### Miyazawa Kenji head ####
MKWorks <- readr::read_csv("data-raw/miyazawa_kenji_head.csv")
usethis::use_data(MKWorks, overwrite = TRUE)

#### NekoCorpus ####
NekoText <- readr::read_lines("data-raw/wagahaiwa_nekodearu.txt")
NekoText <- purrr::discard(NekoText, ~ . == "")
usethis::use_data(NekoText, overwrite = TRUE)

remove(tmp)
remove(list_all)
remove(AozoraBunkoSnapshot)
remove(MiyazawaKenji)
remove(MKWorks)
remove(NekoText)
