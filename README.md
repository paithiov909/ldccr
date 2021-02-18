
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
#> $ category   <chr> "dokujo-tsushin", "dokujo-tsushin", "dokujo-tsushin", "d...
#> $ file_path  <chr> "C:\\Users\\user\\AppData\\Local\\Temp\\Rtmpikw7wR/text/...
#> $ source     <chr> "http://news.livedoor.com/article/detail/4778030/", "htt...
#> $ time_stamp <chr> "2010-05-22T14:30:00+0900", "2010-05-21T14:30:00+0900", ...
#> $ body       <chr> "友人代表のスピーチ、独女はどうこなしている？\n\n　もうすぐジューン・ブライドと呼ばれる６月。独女の中には自...
```

See also [livedoor
ニュースコーパス](https://www.rondhuit.com/download.html#ldcc) for more
details of the Livedoor News Corpus.

### Download text file from Aozora Bunko

``` r
data("AozoraBunkoSnapshot")

if (!dir.exists("tools")) dir.create("tools")

text <- AozoraBunkoSnapshot %>%
  dplyr::sample_n(1L) %>%
  dplyr::pull("テキストファイルURL") %>%
  ldccr::aozora(directory = "tools") %>%
  readr::read_lines()

dplyr::glimpse(text)
#>  chr [1:12] "午前一時に" "ボードレール" "富永太郎訳" "" "" ...
```

## License

MIT license.
