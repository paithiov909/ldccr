
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
2.  downloader of zipped text files published on [Aozora
    Bunko](https://www.aozora.gr.jp/).

## Supported Corpora

### Monolingual

| …                    | Name                                                          | License                                                               | Link                                                  |
|----------------------|---------------------------------------------------------------|-----------------------------------------------------------------------|-------------------------------------------------------|
| :heavy\_check\_mark: | Live Door News Corpus                                         | [CC BY-ND 2.1 JP](http://creativecommons.org/licenses/by-nd/2.1/jp/)  | [\#](http://www.rondhuit.com/download.html#ldcc)      |
| :no\_entry:          | Japanese Realistic Textual Entailment Corpus                  | [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) | [\#](https://github.com/megagonlabs/jrte-corpus)      |
| :x:                  | JEITA Public Morphologically Tagged Corpus (in ChaSen format) | Unknown                                                               | [\#](https://github.com/julianbetz/yokome-jpn-corpus) |
| :x:                  | Kyoto University and NTT Blog Corpus (KNB Corpus)             | 3-clause BSD license                                                  | [\#](https://nlp.ist.i.kyoto-u.ac.jp/kuntt/)          |

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
#>  chr [1:46] "芸術が必要とする科学" "宮本百合子" "" "" "          一" "" ...
```

## License

MIT license.
