data("MiyazawaKenji")

describe("Check aozora", {
  it("Works properly?", {
    path <- aozora(
      MiyazawaKenji[1, ]$url,
      NULL,
      file.path(getwd())
    )
    content <- readLines(path, encoding = "UTF-8")
    expect_type(content, "character")
  })
})
