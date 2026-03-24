# Generate random-looking IDs from integer ranks

`sqids()` is an alternative to
[`dplyr::row_number()`](https://dplyr.tidyverse.org/reference/row_number.html)
that generates random-looking IDs from integer ranks using [Sqids
(formerly Hashids)](https://sqids.org/).

IDs that generated with `sqids()` can be easily decoded back into the
original ranks using `unsqids()`.

## Usage

``` r
sqids(
  x,
  .salt = sample.int(1000, 3),
  .ties = c("sequential", "min", "max", "dense")
)

unsqids(x)
```

## Arguments

- x:

  For `sqids()`, a vector to rank. You can leave this argument missing
  to refer to the "current" row number in 'dplyr' verbs.

  For `unsqids()`, a character vector of IDs.

- .salt:

  Integers to use with each value of `x` to generate IDs.

- .ties:

  Method to rank duplicate values. One of `"sequential"`, `"min"`,
  `"max"`, or `"dense"`. See `ties` argument of
  [`vctrs::vec_rank()`](https://vctrs.r-lib.org/reference/vec_rank.html)
  for more details.

## Value

For `sqids()`, a character vector of IDs.

For `unsqids()`, integers.

## See also

[sqids/sqids-cpp](https://github.com/sqids/sqids-cpp)

## Examples

``` r
ids <- sqids(c(5, 1, 3, 2, 2, NA))
ids
#> [1] "cjuiea7YwmO" "GpUYec8C9SD" "HnVrUtYxjxO" "6Xge9xA9Rhq" "YwEGRTfU80b"
#> [6] NA           
unsqids(ids)
#> [1]  5  1  4  2  3 NA

df <- data.frame(
  grp = c(1, 1, 1, 2, 2, 2, 3, 3, 3)
)
# You can use `sqids()` without referencing `x` in dplyr verbs.
dplyr::mutate(df, sqids = sqids(), row_id = unsqids(sqids))
#>   grp       sqids row_id
#> 1   1 eH6wVlCO0ZA      1
#> 2   1 0dTSmtQKakU      2
#> 3   1 pAkeMlWKnO9      3
#> 4   2 1a79sLUZt7r      4
#> 5   2 GQUUYcFb9Ub      5
#> 6   2 xcoeNCjm76h      6
#> 7   3 Z7Md7UY60wE      7
#> 8   3 gWHmfJheCXR      8
#> 9   3 JoagzEH8OKT      9
# Use `.ties` to control how to rank duplicate values.
dplyr::mutate(df, sqids = sqids(grp, .ties = "min"), grp_id = unsqids(sqids))
#>   grp       sqids grp_id
#> 1   1 tCyn3JsAbMw      1
#> 2   1 tCyn3JsAbMw      1
#> 3   1 tCyn3JsAbMw      1
#> 4   2 zhcShwOlmwh      4
#> 5   2 zhcShwOlmwh      4
#> 6   2 zhcShwOlmwh      4
#> 7   3 mcxhx3D6HHY      7
#> 8   3 mcxhx3D6HHY      7
#> 9   3 mcxhx3D6HHY      7
# When you need to generate the same IDs for each group, fix the `.salt`:
dplyr::mutate(df, sqids = sqids(.salt = 1234L), .by = grp)
#>   grp sqids
#> 1   1 Rge1J
#> 2   1 W70Dc
#> 3   1 LQpzb
#> 4   2 Rge1J
#> 5   2 W70Dc
#> 6   2 LQpzb
#> 7   3 Rge1J
#> 8   3 W70Dc
#> 9   3 LQpzb
```
