<!-- README.md is generated from README.Rmd. Please edit that file -->
tie
===

The goal of tie is to tie return values from function to

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
library(tie)

x <- rnorm(100)
tie[low,up] <- range(x)
low
#> [1] -2.782042
up
#> [1] 2.379956

tie[,q25,q50,q75,] <- quantile(x)
q25
#> [1] -0.5060406
q75
#> [1] 0.6546022
```
