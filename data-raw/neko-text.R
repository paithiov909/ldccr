
NekoText <- readr::read_lines("data-raw/wagahaiwa_nekodearu.txt")
NekoText <- purrr::discard(NekoText, ~ . == "")

usethis::use_data(NekoText, overwrite = TRUE)
