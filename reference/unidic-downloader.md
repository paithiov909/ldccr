# Download and unzip 'UniDic'

Downloads 'UniDic' of specified version into `dirname`. This function is
a partial port of [polm/unidic-py](https://github.com/polm/unidic-py).
Note that to unzip dictionary will take up 770MB on disk after
downloading.

## Usage

``` r
unidic_availables()

download_unidic(version = "latest", dirname = "unidic")
```

## Arguments

- version:

  String; version of 'UniDic'.

- dirname:

  String; directory to unzip the dictionary.

## Value

Full path to `dirname` is returned invisibly.
