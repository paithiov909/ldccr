## code to prepare `jpaddresses` dataset goes here
## `jpaddresses` originally comes from geolonia/japanese-addresses/data/latest.csv
## which is licensed under the CC BY 4.0
jpaddresses <-
  readr::read_csv("https://github.com/geolonia/japanese-addresses/raw/master/data/latest.csv")

usethis::use_data(jpaddresses, overwrite = TRUE)
