test_that("aozora works", {
  path <- read_aozora(directory = file.path(getwd()))
  content <- readLines(path, encoding = "UTF-8")
  expect_type(content, "character")
})
