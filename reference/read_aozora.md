# Download text file from Aozora Bunko

**\[superseded\]** Downloads a file from specified URL, unzips and
converts it as UTF-8.

If you want to read a large part of texts published at Aozora Bunko, you
can download them at once via
[globis-university/aozorabunko-clean](https://huggingface.co/datasets/globis-university/aozorabunko-clean).

## Usage

``` r
read_aozora(
  url = "https://www.aozora.gr.jp/cards/000081/files/472_ruby_654.zip",
  txtname = NULL,
  directory = file.path(getwd(), "cache")
)
```

## Arguments

- url:

  URL of text download link.

- txtname:

  New file name as which text is saved. If left with `NULL`, keeps name
  of the source file.

- directory:

  Path where new file is saved.

## Value

The path to the file downloaded.
