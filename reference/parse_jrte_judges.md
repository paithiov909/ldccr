# Parse judges column of 'rte.\*.tsv'

Parse judges column of 'rte.\*.tsv'

## Usage

``` r
parse_jrte_judges(tbl)
```

## Arguments

- tbl:

  A tibble returned from
  [`read_jrte()`](https://paithiov909.github.io/ldccr/reference/read_jrte.md)
  of which name is `rte.*.tsv` (this function cannot parse judges of the
  `pn` dataset).

## Value

A tibble.

## See also

Other jrte-reader:
[`jrte_rte_files()`](https://paithiov909.github.io/ldccr/reference/jrte_rte_files.md),
[`parse_jrte_reasoning()`](https://paithiov909.github.io/ldccr/reference/parse_jrte_reasoning.md),
[`read_jrte()`](https://paithiov909.github.io/ldccr/reference/read_jrte.md)
