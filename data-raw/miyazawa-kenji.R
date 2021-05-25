
MiyazawaKenji <- readr::read_csv("data-raw/miyazawa_kenji_list.csv")

usethis::use_data(MiyazawaKenji, overwrite = TRUE)
