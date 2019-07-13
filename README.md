<!-- README.md is generated from README.Rmd. Please edit that file -->

tie
===

`bow` and `neck` can be combined to `tie` to do something similar to
`dplyr::summarise` and `dplyr::mutate` respectively, but allowing to
express how to redistribute parts of the results to their own column.

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(tie)

iris %>% 
  group_by(Species) %>% 
  bow( tie(min, max) := range(Sepal.Length) )
#> # A tibble: 3 x 3
#>   Species      min   max
#>   <fct>      <dbl> <dbl>
#> 1 setosa       4.3   5.8
#> 2 versicolor   4.9   7  
#> 3 virginica    4.9   7.9

iris %>% 
  group_by(Species) %>% 
  neck( tie(min, max) := range(Sepal.Length) )
#> # A tibble: 150 x 7
#> # Groups:   Species [3]
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   min   max
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <dbl> <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa    4.3   5.8
#>  2          4.9         3            1.4         0.2 setosa    4.3   5.8
#>  3          4.7         3.2          1.3         0.2 setosa    4.3   5.8
#>  4          4.6         3.1          1.5         0.2 setosa    4.3   5.8
#>  5          5           3.6          1.4         0.2 setosa    4.3   5.8
#>  6          5.4         3.9          1.7         0.4 setosa    4.3   5.8
#>  7          4.6         3.4          1.4         0.3 setosa    4.3   5.8
#>  8          5           3.4          1.5         0.2 setosa    4.3   5.8
#>  9          4.4         2.9          1.4         0.2 setosa    4.3   5.8
#> 10          4.9         3.1          1.5         0.1 setosa    4.3   5.8
#> # ... with 140 more rows
```
