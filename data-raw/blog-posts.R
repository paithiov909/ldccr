library(magrittr)

md_files <- list.files("data-raw/documents/articles", pattern = "*\\.md$", full.names = TRUE)

df <- purrr::imap_dfr(md_files, function(file, index) {
  md <- readr::read_lines(file)
  html <- commonmark::markdown_html(md)
  paragraphs <- xml2::read_html(html) %>%
    rvest::html_nodes("p") %>%
    rvest::html_text() %>%
    textclean::replace_url() %>%
    purrr::discard(~ . == "") %>%
    stringr::str_c(collapse = " ")
  return(data.frame(
    doc_id = index,
    text = paragraphs
  ))
})

BlogPosts <- quanteda::corpus(df)
usethis::use_data(BlogPosts, overwrite = TRUE)
