
# vanKesselR

<!-- badges: start -->
<!-- badges: end -->

The goal of vanKesselR is to provide lightweight utilities to increase
    productivity by streamlining common, repetitive tasks.

## Installation

You can install the development version of hvk from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("kesselhwvan/vanKesselR")
```

## setDTthreads

Conditionally configure the number of threads used by data.table

``` r
if (requireNamespace("data.table", quietly = TRUE) && requireNamespace("parallel", quietly = TRUE)) {
  data.table::setDTthreads(threads = max(1L, parallel::detectCores(logical = TRUE) - 1))
}
```

