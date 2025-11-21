# Read the ja.text8 corpus

Downloads and reads the ja.text8 corpus as a tibble.

## Usage

``` r
read_ja_text8(
  url =
    "https://s3-ap-northeast-1.amazonaws.com/dev.tech-sketch.jp/chakki/public/ja.text8.zip",
  size = NULL
)
```

## Arguments

- url:

  String.

- size:

  Integer. If supplied, samples rows by this argument.

## Value

A tibble.

## Details

By default, this function reads the
[ja.text8](https://github.com/Hironsan/ja.text8) corpus as a tibble by
splitting it into sentences. The ja.text8 as whole corpus consists of
over 582,000 sentences, 16,900,026 tokens, and 290,811 vocabularies.
