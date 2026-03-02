
# hvk

<!-- badges: start -->
<!-- badges: end -->

The goal of hvk is to ...

## Installation

You can install the development version of hvk from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("kesselhwvan/hvk")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
if (requireNamespace("data.table", quietly = TRUE) && requireNamespace("parallel", quietly = TRUE)) {
  data.table::setDTthreads(threads = max(1L, parallel::detectCores(logical = TRUE) - 1))
}
```

