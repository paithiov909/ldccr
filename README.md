
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ldccr

<!-- badges: start -->
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

## Supported Corpora

### Monolingual

| …                  | Name                                                          | License                                                               | Link                                                  |
|--------------------|---------------------------------------------------------------|-----------------------------------------------------------------------|-------------------------------------------------------|
| :heavy_check_mark: | Live Door News Corpus                                         | [CC BY-ND 2.1 JP](http://creativecommons.org/licenses/by-nd/2.1/jp/)  | [\#](http://www.rondhuit.com/download.html#ldcc)      |
| :heavy_check_mark: | Japanese Realistic Textual Entailment Corpus                  | [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) | [\#](https://github.com/megagonlabs/jrte-corpus)      |
| :x:                | JEITA Public Morphologically Tagged Corpus (in ChaSen format) | Unknown                                                               | [\#](https://github.com/julianbetz/yokome-jpn-corpus) |

### Multilingual

> Currently not supported.

## Download text file from Aozora Bunko

``` r
if (!dir.exists("cache")) dir.create("cache")

text <- ldccr::AozoraBunkoSnapshot %>%
  dplyr::sample_n(1L) %>%
  dplyr::pull("テキストファイルURL") %>%
  ldccr::read_aozora(directory = "cache") %>%
  readr::read_lines()

dplyr::glimpse(text)
#>  chr [1:331] "フランダースの犬" "A Dog of Flanders" ...
```

## License

MIT license.
