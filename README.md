<!-- README.md is generated from README.Rmd. Please edit that file -->
tie
===

`bow` and `tie` can be combined to do something similar to `dplyr::summarise`, but allowing to express how to redistribute parts of the results to their own column.

``` r
library(tie)

iris %>% 
  dplyr::group_by(Species) %>% 
  bow( tie(min, max) := range(Sepal.Length) )
#> # A tibble: 3 x 3
#>   Species      min   max
#>   <fct>      <dbl> <dbl>
#> 1 setosa      4.30  5.80
#> 2 versicolor  4.90  7.00
#> 3 virginica   4.90  7.90
```
