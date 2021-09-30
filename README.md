
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ldccr

<!-- badges: start -->
<!-- badges: end -->

> Various Japanese Corpus Parser

## Installation

``` r
remotes::install_github("paithiov909/ldccr")
```

## Supported Corpus

| …   | Name                                         | License                                                               | Link                                             |
|-----|----------------------------------------------|-----------------------------------------------------------------------|--------------------------------------------------|
| 1   | Live Door News Corpus                        | [CC BY-ND 2.1 JP](http://creativecommons.org/licenses/by-nd/2.1/jp/)  | [\#](http://www.rondhuit.com/download.html#ldcc) |
| 2   | Japanese Realistic Textual Entailment Corpus | [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) | [\#](https://github.com/megagonlabs/jrte-corpus) |

## Download text file from Aozora Bunko

``` r
if (!dir.exists("cache")) dir.create("cache")

text <- ldccr::AozoraBunkoSnapshot %>%
  dplyr::sample_n(1L) %>%
  dplyr::pull("テキストファイルURL") %>%
  ldccr::read_aozora(directory = "cache") %>%
  readr::read_lines()

dplyr::glimpse(text)
#>  chr [1:162] "世界怪談名作集" "信号手" "ディッケンズ Charles Dickens" ...
```

## License

MIT license.
