
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
# install.packages("pak")
pak::pak("paithiov909/ldccr")
```

## Supported Corpora

### Monolingual

| …                  | Name                                         | License                                                               | Link                                             |
|--------------------|----------------------------------------------|-----------------------------------------------------------------------|--------------------------------------------------|
| :heavy_check_mark: | Live Door News Corpus                        | [CC BY-ND 2.1 JP](http://creativecommons.org/licenses/by-nd/2.1/jp/)  | [\#](http://www.rondhuit.com/download.html#ldcc) |
| :heavy_check_mark: | Japanese Realistic Textual Entailment Corpus | [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) | [\#](https://github.com/megagonlabs/jrte-corpus) |
| :heavy_check_mark: | ja.text8 corpus                              | [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/)           | [\#](https://github.com/Hironsan/ja.text8)       |

### Multilingual

> Currently not supported.

## Download text file from Aozora Bunko

You can download a text file by specifying `テキストファイルURL` with
`read_aozora()`:

``` r
if (!dir.exists("cache")) dir.create("cache")

text <- ldccr::AozoraBunkoSnapshot |>
  dplyr::slice_sample(n = 1L) |>
  dplyr::pull("テキストファイルURL") |>
  ldccr::read_aozora(directory = "cache") |>
  readr::read_lines()

dplyr::glimpse(text)
#>  chr [1:15] "おしどり" "OSHIDORI" "小泉八雲" "田部隆次訳" ...
```

If you want to read a large part of texts published at Aozora Bunko,
alternatively, you can download them at once via
[globis-university/aozorabunko-clean](https://huggingface.co/datasets/globis-university/aozorabunko-clean).

For example, you can read those texts as follows:

``` r
if (require("polars", quietly = TRUE)) {
  # We are setting `HUGGINGFACE_HUB_CACHE` to a temporary directory.
  # If you don't mind where the cache goes, you don't need to set this.
  withr::with_envvar(c(HUGGINGFACE_HUB_CACHE = tempdir()), {
    path <- hfhub::hub_download(
      "datasets/globis-university/aozorabunko-clean",
      "aozorabunko-dedupe-clean.jsonl.gz"
    )
  })

  df <- pl$read_ndjson(path)

  df$unnest()$
    select(
      pl$col("作品ID", "人物ID")$str$to_integer(),
      pl$col("作品名", "text")
    )
  # To convert this into a tibble, follow with `$to_dataframe() |> dplyr::as_tibble()`.
}
#> aozorabunko-dedupe-clean.jsonl.gz ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ | 241 MB/241 …
#> shape: (16_951, 4)
#> ┌────────┬────────┬──────────────────────────────┬─────────────────────────────────┐
#> │ 作品ID ┆ 人物ID ┆ 作品名                       ┆ text                            │
#> │ ---    ┆ ---    ┆ ---                          ┆ ---                             │
#> │ i64    ┆ i64    ┆ str                          ┆ str                             │
#> ╞════════╪════════╪══════════════════════════════╪═════════════════════════════════╡
#> │ 59898  ┆ 1257   ┆ ウェストミンスター寺院       ┆ 深いおどろきにうたれて、        │
#> │        ┆        ┆                              ┆ 名高いウェストミンスターに      │
#> │        ┆        ┆                              ┆ 真鍮や…                         │
#> │ 56078  ┆ 1257   ┆ 駅伝馬車                     ┆ いざ、これより樂しまむ、        │
#> │        ┆        ┆                              ┆ 仕置を受くる憂なく、            │
#> │        ┆        ┆                              ┆ 遊びたのしむ…                   │
#> │ 60224  ┆ 1257   ┆ 駅馬車                       ┆ すべてよし。                    │
#> │        ┆        ┆                              ┆ 何して遊ぼと                    │
#> │        ┆        ┆                              ┆ 叱られない。                    │
#> │        ┆        ┆                              ┆ 時はきた。                      │
#> │        ┆        ┆                              ┆ さっさ…                         │
#> │ 60225  ┆ 1257   ┆ 寡婦とその子                 ┆ 年老いた人をいたわりなさい。そ  │
#> │        ┆        ┆                              ┆ の銀髪は、                      │
#> │        ┆        ┆                              ┆ 名誉と尊敬をつねに…             │
#> │ 60231  ┆ 1257   ┆ クリスマス                   ┆ 　だが、あのなつかしい、思い出  │
#> │        ┆        ┆                              ┆ ふかいクリスマスのお爺さんはも… │
#> │ …      ┆ …      ┆ …                            ┆ …                               │
#> │ 55622  ┆ 1395   ┆ 夢                           ┆ 　夢の話をするのはあまり気のき  │
#> │        ┆        ┆                              ┆ いたことではない。確か痴人夢を… │
#> │ 49876  ┆ 1395   ┆ 『劉生画集及芸術観』について ┆ 　自分は現代の画家中に岸田君ほ  │
#> │        ┆        ┆                              ┆ ど明らかな「成長」を示している… │
#> │ 49913  ┆ 1395   ┆ 霊的本能主義                 ┆ 一                              │
#> │        ┆        ┆                              ┆                                 │
#> │        ┆        ┆                              ┆ 　荒漠たる秋の野に立つ。星は月  │
#> │        ┆        ┆                              ┆ の御座を囲み月は清らかに…       │
#> │ 49914  ┆ 1395   ┆ 露伴先生の思い出             ┆ 　関東大震災の前数年の間、先輩  │
#> │        ┆        ┆                              ┆ たちにまじって露伴先生から俳諧… │
#> │ 45210  ┆ 1185   ┆ 純粋経済学要論               ┆ 　　　　　訳者序                │
#> │        ┆        ┆                              ┆                                 │
#> │        ┆        ┆                              ┆ 　一九〇九年、レオン・ワルラス  │
#> │        ┆        ┆                              ┆ の七十五歳…                     │
#> └────────┴────────┴──────────────────────────────┴─────────────────────────────────┘
```

> Note: This example requires
> [polars](https://pola-rs.github.io/r-polars/) to read a gzipped NDJSON
> file. For installation of polars, please see [Installation
> details](https://pola-rs.github.io/r-polars/vignettes/install.html).

## License

MIT license.
