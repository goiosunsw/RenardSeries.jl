# RenardSeries

Approximate values to logarithmic divisions of the interval 1..10.

Tries to mimic ISO 3.

## Background

For values that can be distributed throughout several orders of magnitude, it doesn´t make 
much sense to approximate always to a fixed precision.

Renard series divides the interval from 1 to 10 into 5, 10, 20, 40 or 80 values with 
approximate fixed successive ratios. These values can then be repeated for tens, hundreds, etc.

For more information see https://en.wikipedia.org/wiki/Renard_series

## Usage

Select the R-series (5, 10, 20, 40 or 80) 
and a resolution (level of approximation to the exact logarithmic divisions)

The default is to use the R10 series with high resolution (approximate to nearest 0.05)

```jldoctest
julia> roundR(3.1415)
3.15

julia> roundR.((1:5)*100, series=5, resolution=:lo)
5-element Vector{Float64}:
 100.0
 160.0
 250.0
 400.0
 400.0
```

[![Build Status](https://github.com/goiosunsw/RenardSeries.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/goiosunsw/RenardSeries.jl/actions/workflows/CI.yml?query=branch%3Amain)
