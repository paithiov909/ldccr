
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ldccr

<!-- badges: start -->

[![ldccr status
badge](https://paithiov909.r-universe.dev/badges/ldccr)](https://paithiov909.r-universe.dev)
<!-- badges: end -->

## Overview

ldccr is utilities for various Japanese corpora.

The goal of ldccr package is to make easy to use Japanese language
resources.

This package provides:

1.  parsers for several Japanese corpora that are free or open licensed
    (non proprietary).
2.  a downloader of zipped text files published on [Aozora
    Bunko](https://www.aozora.gr.jp/).

## Installation

``` r
install.packages("ldccr", repos = c("https://paithiov909.r-universe.dev", "https://cloud.r-project.org"))
```

## Supported Corpora

### Monolingual

| …                    | Name                                         | License                                                               | Link                                             |
| -------------------- | -------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------ |
| :heavy\_check\_mark: | Live Door News Corpus                        | [CC BY-ND 2.1 JP](http://creativecommons.org/licenses/by-nd/2.1/jp/)  | [\#](http://www.rondhuit.com/download.html#ldcc) |
| :heavy\_check\_mark: | Japanese Realistic Textual Entailment Corpus | [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) | [\#](https://github.com/megagonlabs/jrte-corpus) |
| :heavy\_check\_mark: | ja.text8 corpus                              | [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/)           | [\#](https://github.com/Hironsan/ja.text8)       |

### Multilingual

> Currently not supported.

## Download text file from Aozora Bunko

``` r
if (!dir.exists("cache")) dir.create("cache")

text <- ldccr::AozoraBunkoSnapshot |>
  dplyr::sample_n(1L) |>
  dplyr::pull("テキストファイルURL") |>
  ldccr::read_aozora(directory = "cache") |>
  readr::read_lines()

dplyr::glimpse(text)
#>  chr [1:16] "雪子さんの泥棒よけ" "夢野久作" ...
```

## License

MIT license.
