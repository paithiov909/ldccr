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
