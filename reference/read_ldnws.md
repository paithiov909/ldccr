# Read the Livedoor News Corpus

Downloads and reads the Livedoor News Corpus. The result of this
function is memoised with
[`memoise::memoise()`](https://memoise.r-lib.org/reference/memoise.html)
internally.

## Usage

``` r
read_ldnws(
  url = "https://www.rondhuit.com/download/ldcc-20140209.tar.gz",
  exdir = tempdir(),
  keep = ldnws_categories(),
  collapse = "\n\n",
  include_title = TRUE
)
```

## Arguments

- url:

  String. If left with `NULL`, the function will skip downloading the
  file.

- exdir:

  String. Directory to tempolarily untar text files.

- keep:

  Categories to parse and keep in the tibble.

- collapse:

  String with which [`base::paste()`](https://rdrr.io/r/base/paste.html)
  collapses lines.

- include_title:

  Logical. Whether to include title in text body field. Defaults to
  `TRUE`.

## Value

A tibble.

## Details

This function downloads the Livedoor News Corpus and parses it to a
tibble. For details about the Livedoor News Corpus, please see [thie
page](https://www.rondhuit.com/download.html#ldcc).

## See also

Other ldnws-reader:
[`ldnws_categories()`](https://paithiov909.github.io/ldccr/reference/ldnws_categories.md)
