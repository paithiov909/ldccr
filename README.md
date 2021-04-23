
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ldccr

<!-- badges: start -->
<!-- badges: end -->

> Japanese Corpus Parser for R

## Installation

``` r
remotes::install_github("paithiov909/ldccr")
```

## Usage

### Download and parse the Livedoor News Corpus

``` r
corpus <- ldccr::parse_ldcc()
#> Parsing dokujo-tsushin...
#> Parsing it-life-hack...
#> Parsing kaden-channel...
#> Parsing livedoor-homme...
#> Parsing movie-enter...
#> Parsing peachy...
#> Parsing smax...
#> Parsing sports-watch...
#> Parsing topic-news...
#> Done.

dplyr::glimpse(corpus)
#> Rows: 7,367
#> Columns: 5
#> $ category   <chr> "dokujo-tsushin", "dokujo-tsushin", "dokujo-tsushin", "doku~
#> $ file_path  <chr> "C:\\Users\\user\\AppData\\Local\\Temp\\RtmpaKmgAY/text/dok~
#> $ source     <chr> "http://news.livedoor.com/article/detail/4778030/", "http:/~
#> $ time_stamp <chr> "2010-05-22T14:30:00+0900", "2010-05-21T14:30:00+0900", "20~
#> $ body       <chr> "友人代表のスピーチ、独女はどうこなしている？\n\n　もうすぐ~
```

See also [livedoor
ニュースコーパス](https://www.rondhuit.com/download.html#ldcc) for more
details of the Livedoor News Corpus.

### Download text file from Aozora Bunko

``` r
data("AozoraBunkoSnapshot")

if (!dir.exists("cache")) dir.create("cache")

text <- AozoraBunkoSnapshot %>%
  dplyr::sample_n(1L) %>%
  dplyr::pull("テキストファイルURL") %>%
  ldccr::aozora(directory = "cache") %>%
  readr::read_lines()

dplyr::glimpse(text)
#>  chr [1:107] "早耳三次捕物聞書" "浮世芝居女看板" "林不忘" "" "" ...
```

## License

MIT license.
