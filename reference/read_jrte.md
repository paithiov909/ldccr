# Read the JRTE Corpus

Download and read the Japanese Realistic Textual Entailment Corpus. The
result of this function is memoised with
[`memoise::memoise()`](https://memoise.r-lib.org/reference/memoise.html)
internally.

## Usage

``` r
read_jrte(
  url = "https://github.com/megagonlabs/jrte-corpus/archive/refs/heads/master.zip",
  exdir = tempdir(),
  keep = jrte_rte_files(),
  keep_rhr = FALSE,
  keep_pn = FALSE
)
```

## Arguments

- url:

  String. If left with `NULL`, the function will skip downloading the
  file.

- exdir:

  String. Path to tempolarily unzip text files.

- keep:

  List. File names to parse and keep in returned value.

- keep_rhr:

  Logical. If supplied `TRUE`, keeps `rhr.tsv`.

- keep_pn:

  Logical. If supplied `TRUE`, keeps `pn.tsv`.

## Value

A list of tibbles.

## See also

Other jrte-reader:
[`jrte_rte_files()`](https://paithiov909.github.io/ldccr/reference/jrte_rte_files.md),
[`parse_jrte_judges()`](https://paithiov909.github.io/ldccr/reference/parse_jrte_judges.md),
[`parse_jrte_reasoning()`](https://paithiov909.github.io/ldccr/reference/parse_jrte_reasoning.md)
