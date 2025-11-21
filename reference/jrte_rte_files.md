# Data for Textual Entailment

Data for Textual Entailment

## Usage

``` r
jrte_rte_files(
  keep = c("rte.nlp2020_base", "rte.nlp2020_append", "rte.lrec2020_surf",
    "rte.lrec2020_sem_short", "rte.lrec2020_sem_long", "rte.lrec2020_me")
)
```

## Arguments

- keep:

  Character vector. File names to parse.

## Value

tsv file names.

## See also

Other jrte-reader:
[`parse_jrte_judges()`](https://paithiov909.github.io/ldccr/reference/parse_jrte_judges.md),
[`parse_jrte_reasoning()`](https://paithiov909.github.io/ldccr/reference/parse_jrte_reasoning.md),
[`read_jrte()`](https://paithiov909.github.io/ldccr/reference/read_jrte.md)
