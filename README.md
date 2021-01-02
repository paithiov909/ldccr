
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ldccr

<!-- badges: start -->

<!-- badges: end -->

> Livedoor News Corpus Parser for R

## Usage

``` r
remotes::install_github("paithiov909/ldccr")
corpus <- ldccr::parse_ldcc()
```

## About Livedoor News Corpus

See [livedoor ニュースコーパス](https://www.rondhuit.com/download.html#ldcc).

> 概要
> 
> 本コーパスは、NHN Japan株式会社が運営する「livedoor
> ニュース」のうち、下記のクリエイティブ・コモンズライセンスが適用されるニュース記事を収集し、可能な限りHTMLタグを取り除いて作成したものです。
> 
> （中略）
> 
> 収集時期：2012年9月上旬 ダウンロード（通常テキスト）：ldcc-20140209.tar.gz ダウンロード（Apache
> Solr向き）：livedoor-news-data.tar.gz 論文などで引用する場合は、このURLを参照してください。
> 
> ライセンス
> 
> 各記事ファイルにはクリエイティブ・コモンズライセンス「表示 – 改変禁止」が適用されます。
> クレジット表示についてはニュースカテゴリにより異なるため、ダウンロードしたファイルを展開したサブディレクトリにあるそれぞれの
> LICENSE.txt をご覧ください。 livedoor はNHN Japan株式会社の登録商標です。

## License

Under the MIT license.
